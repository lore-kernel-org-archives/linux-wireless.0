Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1KXSdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:33:20 -0500
Subject: Re: [RFC v2 0/8] mesh power saving implementation: indication
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>
In-Reply-To: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154127_723214_750C1617)
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	 (sfid-20111121_154127_723214_750C1617)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:33:17 +0100
Message-ID: <1322159597.5366.37.camel@jlt3.sipsolutions.net> (sfid-20111124_193323_982603_0123F3D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:

> Based on the latest IEEE 802.11s standard the power saving mechanism
> can be divided into the following implementation phases:
> * indication of mesh STAs' power modes in frames;
> * a buffering and identification sending frames in mesh STA;
> * Mesh Awake Window implementation;
> * Peer service periods.
> 
> This patchset implements the phase of indication of mesh STAs'
> power modes in frames. There are two types of mesh power modes:
> * peer power mode: a mesh STA indicates its mesh power mode for each
> mesh peering and obtains the mesh power modes of its peer mesh STAs;
> * non-peer power mode: mesh station also indicates mesh power mode for
> non-peer mesh stations. It determines when non-peer mesh STAs may send
> Probe Request and Mesh Peering Open Request frames to the mesh STA.
> 
> Peer power mode should be indicated with Power Management field in the Frame
> Control field and the Mesh Power Save Level field in all transmitted
> individually addressed Mesh Data or QoS Null frames on this link.
> 
> Non-peer power mode should be indicated with the Power Management
> field in the Frame Control field and the Mesh Power Save Level field
> in the Mesh Capability field in Beacon and Probe Response frames. A
> mesh STA shall also indicate its non-peer mesh power mode with the
> Power Management field in the Frame Control field and the Mesh Power
> Save Level field in the QoS Control field in group addressed Mesh Data
> frames.
> 
> We would appreciate comments and advice.

I just did a cursory review -- I only looked at code style and general
issues.

I expect that Thomas/Javier will review this from a functionality POV, I
have no idea if these per-station things etc. even make sense.

johannes

