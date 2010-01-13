Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:46526 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab0AMSLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 13:11:18 -0500
Received: by pxi3 with SMTP id 3so16717597pxi.16
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 10:11:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263405850-10180-1-git-send-email-abhijeet.kolekar@intel.com>
References: <1263405850-10180-1-git-send-email-abhijeet.kolekar@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 Jan 2010 10:04:06 -0800
Message-ID: <43e72e891001131004s1eab8bf2jdf94bdd4b2d59281@mail.gmail.com>
Subject: Re: [PATCH v2] cfg80211: fix channel setting for wext
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 13, 2010 at 10:04 AM, Abhijeet Kolekar
<abhijeet.kolekar@intel.com> wrote:
> Patch fixes the bug at
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2139
>
> Currently we cannot set the channel using wext extension
> if we have already associated and disconnected. As
> cfg80211_mgd_wext_siwfreq will not switch the channel if ssid is set.
> This fixes it by clearing the ssid.
> Following is the sequence which it tries to fix.
> modprobe iwlagn
> iwconfig wlan0 essid ""
> ifconfig wlan0 down
> iwconfig wlan0 chan X
>
> wext is marked as deprecate.If we use nl80211 we can easily play with
> setting the channel.
>
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Is this a stable fix as well?

  Luis
