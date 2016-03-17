Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832AbcCQLbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 07:31:10 -0400
Date: Thu, 17 Mar 2016 12:28:53 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00usb: Use usb anchors to manage URB
Message-ID: <20160317112852.GA21830@redhat.com> (sfid-20160317_123115_444867_A2EA6699)
References: <1458149331-2106-1-git-send-email-vishalthanki@gmail.com>
 <20160317084331.GA19458@redhat.com>
 <20160317095317.GA6518@c50.bag.software>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317095317.GA6518@c50.bag.software>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2016 at 10:53:18AM +0100, Vishal Thanki wrote:
> > usb_anchor structure should be embedded in rt2x00_dev structure,
> > otherwise you can kill urb's from other rt2x00 devices, when
> > disconnecting another one.
> > 
> 
> rt2x00_dev structure does not contain any bus specific data structures
> (for example no structures present for USB/PCI). Should I add a void
> *ptr in rt2x00_dev and cast it as usb_anchor in rt2x00usb.c?

No, just add usb_anchor to rt2x00_dev (and include proper header if
needed).

Stanislaw
