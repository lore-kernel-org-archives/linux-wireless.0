Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D423C63777
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 07:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D98F20C56
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 07:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgLCHyd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Dec 2020 02:54:33 -0500
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:38368 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgLCHyd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Dec 2020 02:54:33 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 6DE7D18225636;
        Thu,  3 Dec 2020 07:53:51 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: scent11_41037c3273ba
X-Filterd-Recvd-Size: 4243
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Thu,  3 Dec 2020 07:53:49 +0000 (UTC)
Message-ID: <ffbf22c4a043f73548157c6620781b8f9a00dd40.camel@perches.com>
Subject: Re: [PATCH] [v9] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Wed, 02 Dec 2020 23:53:48 -0800
In-Reply-To: <20201203050947.156241-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20201203050947.156241-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-12-03 at 10:39 +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.

The below is a trivial readability possible enhancement and should not
hinder this patch being applied.

> diff --git a/drivers/net/wireless/purelifi/dbgfs.c b/drivers/net/wireless/purelifi/dbgfs.c
[]
> +ssize_t purelifi_store_frequency(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf,
> +				 size_t len)
> +{
> +	int i, r, row, col, predivider, feedback_divider, output_div_0;
> +	int output_div_1, output_div_2, clkout3_phase;
> +	char values[6][4] = {{0}, {0} };
> +	char usr_input[8] = {0};
> +	bool valid = false;
> +	int rv = 0;
> +
> +	row = 0; col = 0;
> +	for (i = 0; i < min(len, sizeof(values)); i++) {
> +		values[row][col] = buf[i];
> +		col++;
> +		if (buf[i] == 0x20) {
> +			row++;
> +			col = 0;
> +		} else if (buf[i] == 0x0A) {
> +			if (row == 5 && col > 0) {
> +				rv = sscanf((char *)&values[0][0],
> +					    "%d", &predivider);

Aren't the casts to (char *) redundant ?

> +				if (rv != 1)
> +					valid = false;
> +				rv = sscanf((char *)&values[1][0],
> +					    "%d", &feedback_divider);
> +				if (rv != 1)
> +					valid = false;
> +				rv = sscanf((char *)&values[2][0],
> +					    "%d", &output_div_0);
> +				if (rv != 1)
> +					valid = false;
> +				rv = sscanf((char *)&values[3][0],
> +					    "%d", &output_div_1);
> +				if (rv != 1)
> +					valid = false;
> +				rv = sscanf((char *)&values[4][0],
> +					    "%d", &output_div_2);
> +				if (rv != 1)
> +					valid = false;
> +				rv = sscanf((char *)&values[5][0],
> +					    "%d", &clkout3_phase);
> +				if (rv != 1)
> +					valid = false;
> +				valid = true;

trivia: this might be more intelligible with an array and a loop

	int *index[] = {
		&predivider,
		&feedback_divider,
		&output_div_0,
		&output_div_1,
		&output_div_2,
		&clkout3_phase
	};

	valid = true;
	i = 0;
	while (valid && i < ARRAY_SIZE(index)) {
		if (sscanf(&values[i][0], "%d", index[i]) != 1)
			valid = false;
		i++;
	}
		
> +
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (valid) {
> +		usr_input[0] = (char)predivider;
> +		usr_input[1] = (char)feedback_divider;
> +		usr_input[2] = (char)output_div_0;
> +		usr_input[3] = (char)output_div_1;
> +		usr_input[4] = (char)output_div_2;
> +		usr_input[5] = (char)clkout3_phase;
> +
> +		dev_info(dev, "options IP_DIV: %d VCO_MULT: %d OP_DIV_PHY: %d",
> +			 usr_input[0], usr_input[1], usr_input[2]);
> +		dev_info(dev, "OP_DIV_CPU: %d OP_DIV_USB: %d CLK3_PH: %d\n",
> +			 usr_input[3], usr_input[4], usr_input[5]);
> +
> +		r = usb_write_req((const u8 *)&usr_input[0],
> +				  sizeof(usr_input), USB_REQ_SET_FREQ);
> +		if (r < 0)
> +			dev_err(dev, "SET_FREQ failed (%d)\n", r);
> +	} else {
> +		dev_err(dev, "Your options are invalid\n");
> +	}
> +
> +	return len;
> +}



