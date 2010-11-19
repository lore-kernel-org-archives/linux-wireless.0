Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:20773 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab0KSG6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 01:58:25 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAJ6vpUH009692
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 08:58:22 +0200
Subject: Re: [PATCH] wl12xx: Fix kernel crash related to hw recovery and
 interface shutdown
From: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
To: "Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1290086342-12015-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1290086342-12015-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 08:51:52 +0200
Message-ID: <1290149512.20720.100.camel@tukatila-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 14:19 +0100, Oikarinen Juuso (Nokia-MS/Tampere)
wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> It is possible that the op_remove_interface function  is invoked exactly at
> the same time has hw recovery is started. In this case it is possible for the
> interface to be already removed in the op_remove_interface call, which
> currently leads to a kernel warning and a subsequent kernel crash.
> 
> Fix this by ignoring the op_remove_interface call if the interface is already
> down at that point.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Tested-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>

I couldn't see the crash anymore with this patch.

-Tuomas


