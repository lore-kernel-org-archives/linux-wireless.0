Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.234]:39344 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbXBGFjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 00:39:25 -0500
Received: by nz-out-0506.google.com with SMTP id s1so94113nze
        for <linux-wireless@vger.kernel.org>; Tue, 06 Feb 2007 21:39:25 -0800 (PST)
Message-ID: <9e4733910702062139x7157baacx2d47caffb4f4021@mail.gmail.com>
Date: Wed, 7 Feb 2007 00:39:24 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: IFF_BROADCAST and dscape
In-Reply-To: <9e4733910702061846y3117ff20g9bf234b25cb91116@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910702061846y3117ff20g9bf234b25cb91116@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/6/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> Dscape doesn't appear to be setting IFF_BROADCAST. I have an existing
> app that is refusing to load since it wants that flag. Grepping the
> dscape source doesn't show IFF_BROADCAST.

This appears to fix the problem, but I'm not 100% if it is the correct fix.

Index: ieee80211_iface.c
===================================================================
RCS file: /cvsroot/rt2400/source/rt2x00/ieee80211/ieee80211_iface.c,v
retrieving revision 1.21
diff -r1.21 ieee80211_iface.c
78c78
<       ndev->flags = dev->flags & IFF_MULTICAST;
---
>       ndev->flags = dev->flags & (IFF_MULTICAST | IFF_BROADCAST);



-- 
Jon Smirl
jonsmirl@gmail.com
