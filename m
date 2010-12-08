Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35835 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab0LHOpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 09:45:11 -0500
Date: Wed, 8 Dec 2010 09:31:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] cfg80211: Add antenna availability information
Message-ID: <20101208143101.GC2423@tuxdriver.com>
References: <20101208034429.24218.50707.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101208034429.24218.50707.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 12:44:29PM +0900, Bruno Randolf wrote:
> Add a field to wiphy for the hardware to report the availble antennas for
> configuration. Only if this is set to something bigger than zero, will the
> anntenna configuration ops be executed.
> 
> Allthough this could be a simple number of antennas, I defined it as a bitmap
> of antennas which are available for configuration, since it's more consistent
> with the rest of the antenna API and there could be cases where the
> hardware allows only configuration of certain antennas. As it does not make
> much of a difference in size or normal usage, I think it's better to be able to
> support this, in case the need arises.
> 
> The antenna configuration is now also checked against the availabe antennas and
> rejected if it does not match.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> v2:	reject antenna configurations which don't match the available antennas
> ---

Please either put the "v2" part before the "Signed-off-by" or
(preferably) after the "---" line.  Also, make sure to use 3 "-"
characters -- often you use only 2 of them and the results from
applying with "git am" are messy.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
