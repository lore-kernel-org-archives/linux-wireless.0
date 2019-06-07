Return-Path: <SRS0=yCjx=UG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44158C28EBD
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jun 2019 02:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 176F6206BB
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jun 2019 02:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfFGCL6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Jun 2019 22:11:58 -0400
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:34873 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725784AbfFGCL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jun 2019 22:11:58 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 21E89181D3419;
        Fri,  7 Jun 2019 02:11:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: crate03_4b162def26913
X-Filterd-Recvd-Size: 1418
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Fri,  7 Jun 2019 02:11:55 +0000 (UTC)
Message-ID: <c3f982260cdf0749201f5535bf0f3bf9f6bfa7ba.camel@perches.com>
Subject: Re: [PATCH V2] iw: print HE capabilities
From:   Joe Perches <joe@perches.com>
To:     John Crispin <john@phrozen.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Date:   Thu, 06 Jun 2019 19:11:53 -0700
In-Reply-To: <20190528065828.25356-1-john@phrozen.org>
References: <20190528065828.25356-1-john@phrozen.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-05-28 at 08:58 +0200, John Crispin wrote:
> Print the HE MAC/PHY capabilities and MCS/NSS sets.

trivia:

> diff --git a/util.c b/util.c
[]
> +void print_he_info(struct nlattr *nl_iftype)
> +{
> +	struct nlattr *tb[NL80211_BAND_IFTYPE_ATTR_MAX + 1];
> +	struct nlattr *tb_flags[NL80211_IFTYPE_MAX + 1];
> +	char *iftypes[NUM_NL80211_IFTYPES] = {
> +		"Unspec", "Adhoc", "Station", "AP", "AP/VLAN", "WDS", "Monitor",
> +		"Mesh", "P2P/Client", "P2P/Go", "P2P/Device", "OCB", "NAN",
> +	};

Should probably be
	const char * const iftypes[...]


