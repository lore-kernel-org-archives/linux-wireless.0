Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40332 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932172AbcKNMst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:48:49 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v2 2/3] mwifiex: Introduce mwifiex_probe_of() to parse
 common properties
Date: Mon, 14 Nov 2016 12:48:43 +0000
Message-ID: <26d48dadd53945e9bafe5b94e2d4e6f4@SC-EXCH04.marvell.com> (sfid-20161114_134853_005607_4A1E924F)
References: <1478862911-15498-1-git-send-email-akarwar@marvell.com>
 <1478862911-15498-2-git-send-email-akarwar@marvell.com>
 <20161111204957.GC111624@google.com>
In-Reply-To: <20161111204957.GC111624@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Saturday, November 12, 2016 2:20 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; dmitry.torokhov@gmail.com
> Subject: Re: [PATCH v2 2/3] mwifiex: Introduce mwifiex_probe_of() to
> parse common properties
> 
> On Fri, Nov 11, 2016 at 04:45:10PM +0530, Amitkumar Karwar wrote:
> > From: Rajat Jain <rajatja@google.com>
> >
> > Introduce function mwifiex_probe_of() to parse common properties.
> > Since the interface drivers get to decide whether or not the device
> > tree node was a valid one (depending on the compatible property), let
> > the interface drivers pass a flag to indicate whether the device tree
> > node was a valid one.
> 
> Wait, what? I don't understand why this is needed. The current of_node
> user (SDIO) always checks dev->of_node (if !NULL), and if it's not
> matching, it rejects the device and doesn't even try to register the
> card at all. That's a common pattern for DT-based drivers, and I don't
> see why we need to do differently for any other driver (e.g., PCIe).
> 
> So...isn't 'dev->of_node != NULL' an equivalent test to
> 'of_node_valid'?
> Or put another way, mwifiex_add_card() should never see a 'struct
> device' whose of_node is not compatible. Do you agree?

I agree. 'of_node_valid' seems to be redundant here. I will remove it and post updated version.

Regards,
Amitkumar
