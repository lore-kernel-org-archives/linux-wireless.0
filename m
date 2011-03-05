Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3256 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1CEPbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 10:31:03 -0500
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Sheldon Neuberger" <neuberger@gmail.com>
Subject: Re: brcm80211: ieee80211_register_hw failed, status -22
References: <AANLkTinm_O2e5G=zn9umQdRrysyyeX-yndcmD6-9J5Yf@mail.gmail.com>
Date: Sat, 5 Mar 2011 16:30:43 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vrvmnd103ri7v4@arend-laptop>
In-Reply-To: <AANLkTinm_O2e5G=zn9umQdRrysyyeX-yndcmD6-9J5Yf@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 04 Mar 2011 13:59:34 +0100, Sheldon Neuberger  
<neuberger@gmail.com> wrote:

> I'm using compat-wireless-2011-03-03 and when the brcm80211 module
> loads at boot up, I'm getting an an error. See dmesg below.
>

I had a look at the tarball. The warning originates from following WARN_ON  
call.

if (!have_band) {
	WARN_ON(1);
	return -EINVAL;
}

This would mean that the brcm80211 does not provide band information for  
2.4GHz nor 5GHz bands. For the bcm4313 which is what you seem to have the  
2.4 GHz band info should be provided. From the trace and log I see no  
reason why brcm80211 would not fill this info.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

