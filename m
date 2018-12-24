Return-Path: <SRS0=QFll=PB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADF7C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 11:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4EB52176F
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 11:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="QbyXG7DK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbeLXLJm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:09:42 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50302 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbeLXLJl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Dec 2018 06:09:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oL63zbLCFSqoFe+976HgG14BtByyjQTTSPhlM+3eyqM=; b=QbyXG7DKVFBTyoiqRuNJzXqwB
        GarGGaoU38f8CWVWlKWlcv1uINQEMhOLLUIWzsvwpJ5jRL7FHh9ln0nDZPuA6se2SRq3jslHTEzjP
        vPt2Z2pqIrp/feEciu7xbn+B7TUv58UowOByiJaFipKMmqPXLkrvUHv/LSCPQomZLgvg8=;
Received: from n2100.armlinux.org.uk ([2002:4e20:1eda:1:214:fdff:fe10:4f86]:56734)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gbO70-0006wx-Kb; Mon, 24 Dec 2018 11:09:34 +0000
Received: from linux by n2100.armlinux.org.uk with local (Exim 4.90_1)
        (envelope-from <linux@n2100.armlinux.org.uk>)
        id 1gbO6x-0004w1-St; Mon, 24 Dec 2018 11:09:28 +0000
Date:   Mon, 24 Dec 2018 11:09:25 +0000
From:   Russell King - ARM Linux <linux@armlinux.org.uk>
To:     rafal@milecki.pl, arend.vanspriel@broadcom.com,
        kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20181224110925.GY26090@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Commit 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
appears to have broken hostapd 2.4, thereby causing a user visible
regression when upgrading across the 4.18 boundary (e.g. 4.13 to
4.19).

The presence of this flag causes nl80211 to add an additional
attribute to the netlink wiphy reply:

                if ((rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
                    nla_put_u32(msg, NL80211_ATTR_DEVICE_AP_SME,
                                rdev->wiphy.ap_sme_capa))
                        goto nla_put_failure;

which is then parsed by hostapd using a presence/absence test for
this property (the value of the property is meaningless):

        nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
                  genlmsg_attrlen(gnlh, 0), NULL);
...
        if (tb[NL80211_ATTR_DEVICE_AP_SME])
                info->device_ap_sme = 1;

This causes hostapd to then attempt to subscribe to management
frames (via nl80211_mgmt_subscribe_ap_dev_sme()):

        if (nl80211_register_frame(bss, bss->nl_mgmt,
                                   (WLAN_FC_TYPE_MGMT << 2) |
                                   (WLAN_FC_STYPE_ACTION << 4),
                                   NULL, 0) < 0)

and brcmfmac does not support passing any management frames in AP
mode (brcmf_txrx_stypes[NL80211_IFTYPE_AP] is empty).  That causes
nl80211_register_frame() to fail, and hostapd fails to initialise.

Checking the hostapd versions (including up to 2.7) shows that
nothing has changed, so this change has broken the ability for
hostapd to be used with brcmfmac - thereby causing a user-visible
regression.

Can this commit be reverted to fix this regression please?

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
