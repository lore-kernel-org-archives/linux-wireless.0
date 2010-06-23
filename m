Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58660 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0FWRzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 13:55:47 -0400
Subject: Re: [PATCH] ath9k: Fix the LED behaviour in idle unassociated
 state.
From: Pavel Roskin <proski@gnu.org>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1277275109-4662-1-git-send-email-vnatarajan@atheros.com>
References: <1277275109-4662-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain
Date: Wed, 23 Jun 2010 13:55:40 -0400
Message-Id: <1277315740.3562.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-23 at 12:08 +0530, Vivek Natarajan wrote:
> LED should be ON when the radio is put into FULL SLEEP mode during the idle
> unassociated state.

Why?  Is there any written policy for the LED behavior?  I think we want
to conserve power if sleeping, which means turning LEDs off.

Or is it a workaround for some quirk in Atheros hardware?

In any case, I don't like the new comment.  The comment says "Keep the
LED on...", but the code is still turning the LED off.

-- 
Regards,
Pavel Roskin
