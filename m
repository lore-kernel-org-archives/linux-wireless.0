Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1IPJ4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 05:56:10 -0400
Subject: Re: [PATCH 3.1] iwlagn: workaround bug crashing some APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>
In-Reply-To: <CAGXE3d8rVyF9VTtjDtatvX9e6dKLAGtYNEq5wEfvNGLtu_U9UQ@mail.gmail.com> (sfid-20110916_114247_284504_C5223F3E)
References: <1316100982-1815-1-git-send-email-wey-yi.w.guy@intel.com>
	 <CAGXE3d8rVyF9VTtjDtatvX9e6dKLAGtYNEq5wEfvNGLtu_U9UQ@mail.gmail.com>
	 (sfid-20110916_114247_284504_C5223F3E)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 11:56:04 +0200
Message-ID: <1316166964.4130.4.camel@jlt3.sipsolutions.net> (sfid-20110916_115618_903809_48929763)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 11:42 +0200, Helmut Schaa wrote:
> <Hi,
> 
> On Thu, Sep 15, 2011 at 5:36 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > From: Don Fry <donald.h.fry@intel.com>
> >
> > This patch reverts commit 9b7688328422b88a7a15dc0dc123ad9ab1a6e22d which
> > was introduced in 2.6.38-rc1.  It works around a problem where the iwlagn
> > driver stimulates a bug crashing (requiring power cycle to recover) some
> > APs under heavy traffic.
> 
> [...]
> 
> > +       /*
> > +        * Including the following line will crash some AP's.  This
> > +        * workaround removes the stimulus which causes the crash until
> > +        * the AP software can be fixed.
> >        hw->max_tx_aggregation_subframes = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
> > +        */
> 
> Would be interesting to know which AP models suffer from this issue since
> other drivers might also be affected if max_tx_aggregation_subframes is set
> to something != 64 or 0.
> 
> Did this appear with the previous LINK_QUAL_AGG_FRAME_LIMIT_DEF
> value of 31 too?
> 
> If we can crash APs by sending values != 64 or 0 it might even make sense
> to not allow drivers to overwrite the max AMPDU size ...

It isn't that sending that directly crashes the APs right away. It still
needs some traffic, so there's a possibility that we send too long
AMPDUs or something else like that and just can't find that bug ...

johannes

