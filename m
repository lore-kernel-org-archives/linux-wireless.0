Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84617C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 08:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47359205C9
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 08:25:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47359205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbeJPQOa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 12:14:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeJPQOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 12:14:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39F67318014A;
        Tue, 16 Oct 2018 08:25:14 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0DD26248D;
        Tue, 16 Oct 2018 08:25:13 +0000 (UTC)
Date:   Tue, 16 Oct 2018 10:25:11 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v4 06/13] rtw88: fw and efuse files
Message-ID: <20181016082511.GD4158@redhat.com>
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
 <1539421245-11847-7-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539421245-11847-7-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 16 Oct 2018 08:25:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 13, 2018 at 05:00:38PM +0800, yhchuang@realtek.com wrote:
> +rtw_beacon_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> +{
> +	struct sk_buff *skb_new;
> +
> +	if (vif->type != NL80211_IFTYPE_AP &&
> +	    vif->type != NL80211_IFTYPE_ADHOC &&
> +	    !ieee80211_vif_is_mesh(vif)) {
> +		skb_new = alloc_skb(1, GFP_KERNEL);
> +		skb_put(skb_new, 1);

Error check.

Thanks
Stanislaw
