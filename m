Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43419 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaJ3JpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 05:45:15 -0400
Message-ID: <1414662308.1823.4.camel@jlt4.sipsolutions.net> (sfid-20141030_104521_160790_505F77C9)
Subject: Re: [PATCH] wireless: nl80211: Broadcast CMD_NEW_INTERFACE and
 CMD_DEL_INTERFACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Oct 2014 10:45:08 +0100
In-Reply-To: <5452016E.70303@linux.intel.com>
References: <1414413807-7649-1-git-send-email-tomasz.bursztyka@linux.intel.com>
		 (sfid-20141027_134340_833740_6984A324) <1414597472.1827.12.camel@jlt4.sipsolutions.net>
	 <5452016E.70303@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-30 at 11:14 +0200, Tomasz Bursztyka wrote:
> Hi Johannes,
> 
> > It really bloats the*arguments*  more than anything, no way to change
> > that, say by sending the delete message before the wdev is destroyed?
> 
> You mean building the nlmsg before? (sending it would be wrong if the 
> deletion fails afterwards)

Ah, I didn't realize that it could fail, but yeah, then it'd be
something like

msg = build_message(wdev)
if (delete(wdev) != 0)
  free(msg)
else
  send(msg)

johannes

