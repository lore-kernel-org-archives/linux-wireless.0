Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22-vm1.bullet.mail.ukl.yahoo.com ([217.12.10.75]:36962 "HELO
	nm22-vm1.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755418Ab2EQLri (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 07:47:38 -0400
From: Marek Lindner <lindner_marek@yahoo.de>
To: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
Subject: Re: [RFC 0/2] bind RTS threshold to vif.
Date: Thu, 17 May 2012 19:40:42 +0800
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com>
In-Reply-To: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201205171940.42671.lindner_marek@yahoo.de> (sfid-20120517_134742_514733_D2414FD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, May 17, 2012 17:58:41 Lukasz Kucharczyk wrote:
> following patches bind rts threshold to vif.
> I think it might be useful in multi channel operation
> (one chip handling multiple virtual interfaces on different
> channels).
> 
> RTS threshold is still set with NL80211_CMD_SET_WIPHY, and can
> be now executed for both hw and vif, so it's backward compatible
> (from userspace).

As much as I like the idea of having per vif rts/cts settings, the rts/cts 
user space API is useless as long as these settings are bluntly ignored by 
certain rate control algorithms. I already had to explain to a dozen people 
who turned rts/cts off via this API does not really turn it off.
Therefore, I suggest to remove the rts/cts API altogether, so that nobody 
falls into the trap of believing this does anything useful.

Regards,
Marek
