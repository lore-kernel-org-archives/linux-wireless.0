Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965042AbcIWMQZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 08:16:25 -0400
Date: Fri, 23 Sep 2016 14:16:18 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
Message-ID: <20160923141618.1fcfd809@endymion> (sfid-20160923_141628_666620_7C3D04B9)
In-Reply-To: <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
References: <20160922115116.149c599c@endymion>
        <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Thu, 22 Sep 2016 10:09:58 -0500, Larry Finger wrote:
> Do you build your own kernel, or are you using openSUSE's supplied version? If 
> the latter, I will need to think how we might debug the issue. If the former, 
> please add the attached patch.

Lost network this morning, but no error message. We restarted the
network service, things were back up and the error message was logged
then:

rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case 92 not processed

So I think this is happening when the interface is put down, and is
probably not related with the loss of connectivity. But it would be
good to understand and fix it nevertheless.

92 is HAL_DEF_WOWLAN. I see it is handled differently in 2 other
rtlwifi drivers: rtl8192cu ignores it, while rtl8821ae processes it:

	case HAL_DEF_WOWLAN:
		if (ppsc->wo_wlan_mode)
			*((bool *)(val)) = true;
		else
			*((bool *)(val)) = false;
		break;

I don't know what is the appropriate course of action in the case of
the rtl8192ce. Let me know if you need anything else from me.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
