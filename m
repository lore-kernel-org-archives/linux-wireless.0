Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56725 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449Ab1F2QHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 12:07:33 -0400
Message-ID: <4E0B4DC4.8050702@gnu.org> (sfid-20110629_180736_615941_9E8343F7)
Date: Wed, 29 Jun 2011 12:07:32 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] ath5k crash (NULL pointer access) when changing
 ANI
References: <1309339683.73960.YahooMailRC@web161214.mail.bf1.yahoo.com>
In-Reply-To: <1309339683.73960.YahooMailRC@web161214.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2011 05:28 AM, Joerg Pommnitz wrote:
> Hello all,
> ath5k will immediately crash when issuing the following command:
>
> echo 2>  /sys/class/ieee80211/phy0/device/ani/ani_mode
>
> The crash log looks like this:
>
> [   66.425365] BUG: unable to handle kernel NULL pointer dereference at 00000100
> [   66.425652] IP: [<e08e3008>] ath5k_ani_init+0xe/0x399 [ath5k]

It looks like we have a major bug in the ath5k sysfs code!  drvdata is 
set to hw as it should, but the sysfs code assumes it's set to sc.  I'm 
testing a patch now.

-- 
Regards,
Pavel Roskin
