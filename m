Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11186 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbeCUNzu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 09:55:50 -0400
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 04/11] staging: wilc1000: refactor WILC_WFI_p2p_rx() to
 avoid line over 80 char
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <1521564944-3565-5-git-send-email-ajay.kathat@microchip.com>
Message-ID: <24234901-20d9-aef4-49ed-df9d3d4a6dee@microchip.com> (sfid-20180321_145554_708213_99A37208)
Date: Wed, 21 Mar 2018 15:55:46 +0200
MIME-Version: 1.0
In-Reply-To: <1521564944-3565-5-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also good for me, only one minor thing mentioned below.

On 20.03.2018 18:55, Ajay Singh wrote:
> +	if (subtype == GO_NEG_REQ || subtype == GO_NEG_RSP ||
> +	    subtype == P2P_INV_REQ || subtype == P2P_INV_RSP) {
> +		for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
> +			if (buff[i] == P2PELEM_ATTR_ID &&
> +			    !(memcmp(p2p_oui, &buff[i + 2], 4))) {
You can remove  "(" ")" around memcmp. Your choice.

> +				wilc_wfi_cfg_parse_rx_action(&buff[i + 6],
> +							     size - (i + 6));
> +				break;
> +			}
> +		}
> +	}
