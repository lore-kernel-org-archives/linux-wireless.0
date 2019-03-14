Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813CDC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 23:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A3D218A2
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 23:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfCNXXY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 19:23:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:54210 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfCNXXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 19:23:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Mar 2019 16:23:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,479,1544515200"; 
   d="scan'208";a="151834895"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga002.fm.intel.com with ESMTP; 14 Mar 2019 16:23:23 -0700
Date:   Thu, 14 Mar 2019 16:16:14 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 03/18] wlcore: simplify/fix/optimize
 reg_ch_conf_pending operations
Message-ID: <20190314231614.GA41447@romley-ivt3.sc.intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
 <1552431636-31511-4-git-send-email-fenghua.yu@intel.com>
 <87a7hxzjda.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7hxzjda.fsf@purkki.adurom.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi, Valo,

On Thu, Mar 14, 2019 at 03:16:33PM +0200, Kalle Valo wrote:
> Fenghua Yu <fenghua.yu@intel.com> writes:
> 
> > From: Paolo Bonzini <pbonzini@redhat.com>
> >
> > Bitmaps are defined on unsigned longs, so the usage of u32[2] in the
> > wlcore driver is incorrect.  As noted by Peter Zijlstra, casting arrays
> > to a bitmap is incorrect for big-endian architectures.
> >
> > When looking at it I observed that:
> >
> > - operations on reg_ch_conf_pending is always under the wl_lock mutex,
> > so set_bit is overkill
> >
> > - the only case where reg_ch_conf_pending is accessed a u32 at a time is
> > unnecessary too.
> >
> > This patch cleans up everything in this area, and changes tmp_ch_bitmap
> > to have the proper alignment.
> >
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> [...]
> 
> >  int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
> >  {
> >  	struct wl12xx_cmd_regdomain_dfs_config *cmd = NULL;
> >  	int ret = 0, i, b, ch_bit_idx;
> > -	u32 tmp_ch_bitmap[2];
> > +	u32 tmp_ch_bitmap[2] __aligned(sizeof(unsigned long));
> >  	struct wiphy *wiphy = wl->hw->wiphy;
> >  	struct ieee80211_supported_band *band;
> >  	bool timeout = false;
> 
> [...]
> 
> > @@ -1754,8 +1751,8 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
> >  		goto out;
> >  	}
> >  
> > -	cmd->ch_bit_map1 = cpu_to_le32(tmp_ch_bitmap[0]);
> > -	cmd->ch_bit_map2 = cpu_to_le32(tmp_ch_bitmap[1]);
> > +	cmd->ch_bit_map1 = tmp_ch_bitmap[0];
> > +	cmd->ch_bit_map2 = tmp_ch_bitmap[1];
> 
> Will sparse still be happy? AFAICS you are now assigning u32 to __le32:
> 
> struct wl12xx_cmd_regdomain_dfs_config {
>        struct wl1271_cmd_header header;
> 
>        __le32 ch_bit_map1;
>        __le32 ch_bit_map2;

Discussion between Peter and Paolo (https://lkml.org/lkml/2019/3/4/521)
may answer your question.

(Sorry I didn't send to you v4 patch set)

> 
> Also this doesn't depend on anything else from this patchset, right? So
> I could apply this directly?

You are right. This patch doesn't rely on other patches from this patchset.
This patch just fixes a split lock issue. You could apply this directly
without other patches.

Thanks.

-Fenghua
