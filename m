Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:40999 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759524AbXEIXZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2007 19:25:23 -0400
Message-ID: <464253CE.2030504@linux.intel.com>
Date: Wed, 09 May 2007 16:05:50 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Specifing rate control algorithm?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ieee80211_init_rate_ctrl_alg is the only function that can select the rate control algorithm by name, and that symbol is not set as EXPORT_SYMBOL.

Currently the stack picks the first one it finds and I can't find a way for the driver or the user to override this behavior (esp. if the rate control algorithm is compiled as a built-in)

Adding EXPORT_SYMBOL for ieee80211_init_rate_ctrl_alg would allow the driver to request the algorithm known to work best with that hardware. 

-or- 

we can change ieee80211_register_hw() to take a 'name' parameter specifying the rate control algorithm to use.  Drivers that don't care can pass NULL and the stack will do what it does now (pick the first algorithm registered with the stack)

Preference?

James
