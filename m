Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1DSMDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 08:03:39 -0400
Date: Tue, 19 Apr 2011 14:03:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 03/10] iwlagn: verify that huge commands are synchronous
Message-ID: <20110419120303.GB2220@redhat.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
 <1303145057-6545-4-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303145057-6545-4-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2011 at 09:44:10AM -0700, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since huge commands all share a single buffer,
> there can only be a single one in flight at a
> time since otherwise they'd overwrite each
> other. This is true in the driver now, but it
> seems like a possible source of bugs, so add
> a test to verify that huge commands are always
> sent synchronously.

I belive WARN_ON(out_meta->flags & CMD_MAPPED) I added, protect from
overwite huge commands buffer already.

