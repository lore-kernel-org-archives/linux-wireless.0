Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8058 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2BBIXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 03:23:19 -0500
Message-ID: <4F2A47F0.8090500@qca.qualcomm.com> (sfid-20120202_092322_462530_040F31BD)
Date: Thu, 2 Feb 2012 10:23:12 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Chilam Ng <chilamng@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: initialize the 'nominal_phy' field in the 'wmi_create_pstream_cmd'
 struct for create_qos command
References: <1328087017-6283-1-git-send-email-chilamng@qca.qualcomm.com>
In-Reply-To: <1328087017-6283-1-git-send-email-chilamng@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2012 11:03 AM, Chilam Ng wrote:
> The nominal_phy field is uninitialized. Initialize it to min_phy_rate for create_qos
> 
> Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>

Thanks, applied with a small change:

> +	pstream.nominal_phy = ((le32_to_cpu(pstream.min_phy_rate) / 1000) / 1000);

Checkpatch complained that this line was too long so I simplified the
equation:

pstream.nominal_phy = le32_to_cpu(pstream.min_phy_rate) / 1000000;

Please holler if I did the math wrong :)

Kalle
