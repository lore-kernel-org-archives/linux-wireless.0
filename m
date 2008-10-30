Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46135 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358AbYJ3RK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:10:57 -0400
From: Chr <chunkeey@web.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] p54: don't report known but unhandled EEPROM codes as unknown
Date: Thu, 30 Oct 2008 18:10:45 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20081029213143.4497.77258.stgit@dv.roinet.com>
In-Reply-To: <20081029213143.4497.77258.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810301810.45647.chunkeey@web.de> (sfid-20081030_181132_805053_E7B8EBEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 October 2008 22:31:43 Pavel Roskin wrote:
> [...]
> +		case PDR_RADIATED_TRANSMISSION_CORRECTION:
> +		case PDR_PRISM_TX_IQ_CALIBRATION:
> +		case PDR_BASEBAND_REGISTERS:
> +		case PDR_PER_CHANNEL_BASEBAND_REGISTERS:
> +			break;
>  		default:
>  			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
>  				le16_to_cpu(entry->code));

what about removing the printk?
since intersil reserved 0x8000-0xffff for it's customers...
so there could be lots of unknown pdr magics.

Regards,
	Chr
