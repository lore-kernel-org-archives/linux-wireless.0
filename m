Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36957 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGNcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 08:32:13 -0500
Date: Tue, 6 Mar 2012 14:33:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	dan.carpenter@oracle.com
Subject: Re: [PATCH v4] {nl,cfg,mac}80211: Implement RSSI threshold for mesh
 peering
Message-ID: <20120306193350.GA3353@tuxdriver.com> (sfid-20120307_143217_080431_6130A757)
References: <1331061810-4100-1-git-send-email-ashok@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331061810-4100-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 06, 2012 at 11:23:30AM -0800, Ashok Nagarajan wrote:
> Mesh peer links are established only if average rssi of the peer
> candidate satisfies the threshold. This is not in 802.11s specification
> but was requested by David Fulgham, an open80211s user. This is a way to avoid
> marginal peer links with stations that are barely within range.
> 
> This patch adds a new mesh configuration parameter, mesh_rssi_threshold. This
> feature is supported only for hardwares that report signal in dBm.
> 
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
> v3:
> use s32 instead of int32_t (Kalle Valo)
> Feature to be supported for devices reporting signal in dBm (Johannes)
> 
> v4:
> Fix potential null pointer deferencing (Dan Carpenter)

I already merged v3 yesterday -- can you rework this as a fix instead?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
