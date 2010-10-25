Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61799 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab0JYOj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:39:27 -0400
Subject: Re: [PATCH 1/7] iwlwifi: warn when send tx power settings during
 scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101025083436.GB2343@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
	 <1287760985.8143.0.camel@wwguy-ubuntu>  <20101025083436.GB2343@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 07:38:36 -0700
Message-Id: <1288017516.3435.7.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-25 at 01:34 -0700, Stanislaw Gruszka wrote:
> Hi Wey
> 
> On Fri, Oct 22, 2010 at 08:23:05AM -0700, Guy, Wey-Yi wrote:
> > On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> > > +	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
> > > +		      "TX Power requested while scanning!\n"))
> > > +		return -EIO;
> > 
> > what reason we want to return -EIO instead of -EAGAIN?
> 
> I though EAGAIN should be used for file nonblock I/O, but seems
> it can be used anywhere when resources are unavailable. If it
> make difference, we can apply this patch instead:
> 
> From 7905309bfeae1a8374d3caa757d9f9383c15d700 Mon Sep 17 00:00:00 2001
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Fri, 22 Oct 2010 13:23:41 +0200
> Subject: [PATCH 1/7 v2] iwlwifi: warn when send tx power settings during scan
> 
> Add WARN_ONCE when scanning is pending. Use STATUS_SCAN_HW bit since we
> can have scan canceled or completed but STATUS_SCANNING bit still set.
> 
> v1 -> v2: replace EIO to EAGAIN
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


