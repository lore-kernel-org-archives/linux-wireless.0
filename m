Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:57583 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab1G1RHv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:07:51 -0400
Message-ID: <4E31975D.2000804@gnu.org> (sfid-20110728_190754_971075_293EB916)
Date: Thu, 28 Jul 2011 13:07:41 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
CC: jouni@qca.qualcomm.com, hostap@lists.shmoo.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 4/4] hostapd: add Automatic Channel Selection (ACS)
 support
References: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com> <1311722362-4070-5-git-send-email-lrodriguez@qca.qualcomm.com>
In-Reply-To: <1311722362-4070-5-git-send-email-lrodriguez@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2011 07:19 PM, Luis R. Rodriguez wrote:
> @@ -1736,7 +1736,18 @@ struct hostapd_config * hostapd_config_read(const char *fname)
>   				errors++;
>   			}
>   		} else if (os_strcmp(buf, "channel") == 0) {
> -			conf->channel = atoi(pos);
> +			if (os_strcmp(pos, "acs_survey") == 0) {
> +				conf->channel = 0;
> +			} else
> +				conf->channel = atoi(pos);

It would be nice to enable ACS also if "channel" is not set at all.  It 
may look strange from the point of view of the code authors.  However, 
it makes sense from the point of view of the end user.  If something is 
not specified, the driver should be able to make a reasonable choice by 
itself.

-- 
Regards,
Pavel Roskin
