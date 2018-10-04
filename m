Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB1DC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 11:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F34F20877
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 11:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F34F20877
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbeJDSfb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 14:35:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbeJDSfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 14:35:31 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9398630820D5;
        Thu,  4 Oct 2018 11:42:38 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 077B3308BDAC;
        Thu,  4 Oct 2018 11:42:37 +0000 (UTC)
Date:   Thu, 4 Oct 2018 13:42:35 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 02/12] rtw88: core files
Message-ID: <20181004114235.GB16819@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-3-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538553748-26364-3-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.24
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 04 Oct 2018 11:42:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 04:02:18PM +0800, yhchuang@realtek.com wrote:
> +static void rtw_restore_port_cfg(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_vif *rtwvif;
> +	u32 config = ~0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry(rtwvif, &rtwdev->vif_list, list)
list_for_each_entry_rcu

> +void rtw_lps_enter_check(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_vif *rtwvif, *lps_if;
> +	u8 assoc_cnt = 0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry(rtwvif, &rtwdev->vif_list, list) {
list_for_each_entry_rcu

> +static struct country_code_to_enum_rd all_countries[] = {
> +	{COUNTRY_CODE_FCC, "US"},
> +	{COUNTRY_CODE_IC, "US"},
> +	{COUNTRY_CODE_ETSI, "EC"},
> +	{COUNTRY_CODE_SPAIN, "EC"},
> +	{COUNTRY_CODE_FRANCE, "EC"},
> +	{COUNTRY_CODE_MKK, "JP"},
> +	{COUNTRY_CODE_MKK1, "JP"},
> +	{COUNTRY_CODE_ISRAEL, "EC"},
> +	{COUNTRY_CODE_TELEC, "JP"},
> +	{COUNTRY_CODE_MIC, "JP"},
> +	{COUNTRY_CODE_GLOBAL_DOMAIN, "JP"},
> +	{COUNTRY_CODE_WORLD_WIDE_13, "EC"},
> +	{COUNTRY_CODE_TELEC_NETGEAR, "EC"},
> +	{COUNTRY_CODE_WORLD_WIDE_13_5G_ALL, "US"},
> +};
> +
> +/* Only these channels allow active
> + * scan on all world regulatory domains
> + */
> +#define RTW_2GHZ_CH01_11	\
> +	REG_RULE(2412 - 10, 2462 + 10, 40, 0, 20, 0)
<snip>
> +static const
> +struct ieee80211_regdomain *rtw_regdomain_select(struct rtw_regulatory *reg)
> +{
> +	switch (reg->country_code) {
> +	case COUNTRY_CODE_FCC:
> +		return &rtw_regdom_no_midband;
> +	case COUNTRY_CODE_IC:
> +		return &rtw_regdom_11;
> +	case COUNTRY_CODE_TELEC_NETGEAR:
> +		return &rtw_regdom_60_64;
> +	case COUNTRY_CODE_ETSI:
> +	case COUNTRY_CODE_SPAIN:
> +	case COUNTRY_CODE_FRANCE:
> +	case COUNTRY_CODE_ISRAEL:
> +		return &rtw_regdom_12_13;
> +	case COUNTRY_CODE_MKK:
> +	case COUNTRY_CODE_MKK1:
> +	case COUNTRY_CODE_TELEC:
> +	case COUNTRY_CODE_MIC:
> +		return &rtw_regdom_14_60_64;
> +	case COUNTRY_CODE_GLOBAL_DOMAIN:
> +		return &rtw_regdom_14;
> +	case COUNTRY_CODE_WORLD_WIDE_13:
> +	case COUNTRY_CODE_WORLD_WIDE_13_5G_ALL:
> +		return &rtw_regdom_12_13_5g_all;
> +	default:
> +		return &rtw_regdom_no_midband;
> +	}

I'm not an expert on this, but I wonder if this is really needed
and standard linux regd stuff can not be used and regulatory
rules read from wireless-regd data-base.

Thanks
Stanislaw
