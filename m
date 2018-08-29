Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43848 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbeH2XEO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 19:04:14 -0400
Message-ID: <1535569548.5215.33.camel@sipsolutions.net> (sfid-20180829_210602_281832_93449A35)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is
 set to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name, sara.sharon@intel.com
Date: Wed, 29 Aug 2018 21:05:48 +0200
In-Reply-To: <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com> (sfid-20180829_210349_105825_7C40E092)
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
         <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
         (sfid-20180829_210349_105825_7C40E092)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-29 at 21:03 +0200, Lorenzo Bianconi wrote:
> Do not try to aggregate packets in a A-MSDU frame and add A-MSDU header
> on the first packet if max_tx_fragments or max_amsdu_subframes are
> set to one
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
> Changes since v1:
> - rebased on top of mac80211 master branch
> - removed ieee80211_amsdu_realloc_pad chunk
> 
Don't you still have to account for the changed header length if the
second one fails or something?

You said you wanted to account for the pad bytes - which now aren't
there - but didn't that also take the changed header of the first
subframe into account?

johannes
