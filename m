Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44975 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaBRJcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 04:32:35 -0500
Date: Tue, 18 Feb 2014 12:31:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	liuhq11@mails.tsinghua.edu.cn
Subject: Re: [PATCH 3/7] rtl818x: check for pci_map_single() success when
 initializing RX ring
Message-ID: <20140218093135.GJ26776@mwanda> (sfid-20140218_103241_482363_811E90A5)
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 18, 2014 at 02:10:42AM +0100, Andrea Merello wrote:
> From: andrea merello <andrea.merello@gmail.com>
> 
> During initialization a number of RX skbs are allocated and mapped
> for DMA.
> Currently if pci_map_single() fails, it will result in passing to the
> HW a wrong DMA address (to write to!).
> 
> This patch detects this condition, eventually it tries to get a more
> luky skb, and if it finally fails to get things right, it makes the
> driver not to initialize, avoiding at least dangerous DMAs.
> 

In normal life then why would pci_map_single() fail even once?  (I am
a newbie with this code so it is an honest question and not a rhetorical
one).

regards,
dan carpenter

