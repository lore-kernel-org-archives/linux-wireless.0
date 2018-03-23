Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50504 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbeCWNoc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 09:44:32 -0400
Message-ID: <1521812659.28252.0.camel@sipsolutions.net> (sfid-20180323_144624_238061_41B120B0)
Subject: Re: [PATCH] ath10k: Implement get_expected_throughput callback
From: Johannes Berg <johannes@sipsolutions.net>
To: akolli@codeaurora.org, Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Antonio Quartulli <a@unstable.cc>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Date: Fri, 23 Mar 2018 14:44:19 +0100
In-Reply-To: <5434de1a4bcdf7341fdeb766e7638760@codeaurora.org> (sfid-20180323_144153_352630_7377CAE0)
References: <1521790620-12267-1-git-send-email-akolli@codeaurora.org>
         <2667699.TbZPxW0hJB@bentobox>
         <5434de1a4bcdf7341fdeb766e7638760@codeaurora.org>
         (sfid-20180323_144153_352630_7377CAE0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-03-23 at 19:11 +0530, akolli@codeaurora.org wrote:
> 
> > > +
> > > +       sinfo->expected_throughput =
> > > +                               
> > > ewma_sta_txrate_read(&arsta->ave_sta_txrate);
> > > +       sinfo->filled |=
> > > BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
> > > +}

> Yes. This looks redundant, I will remove this line,
>   sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);

You don't need any of the changes here in ath10k_sta_statistics().

johannes
