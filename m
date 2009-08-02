Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailin.taunusstein.net ([193.138.96.2]:42385 "EHLO
	mailin.taunusstein.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZHBGdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 02:33:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailin.taunusstein.net (Postfix) with ESMTP id 1A8A247A07
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2009 08:33:38 +0200 (CEST)
Received: from mailin.taunusstein.net ([127.0.0.1])
	by localhost (mail.taunusstein.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dCIAsDmIWNY3 for <linux-wireless@vger.kernel.org>;
	Sun,  2 Aug 2009 08:33:35 +0200 (CEST)
Received: from [192.168.1.45] (u5-2.dsl.vianetworks.de [194.231.189.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "hostmaster@taunusstein.net", Issuer "taunusstein.net Root CA" (verified OK))
	by mailin.taunusstein.net (Postfix) with ESMTPS
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2009 08:33:35 +0200 (CEST)
Message-ID: <4A75333D.9070100@taunusstein.net>
Date: Sun, 02 Aug 2009 08:33:33 +0200
From: Christian Felsing <hostmaster@taunusstein.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Multiple BSSID problem with hostapd
References: <4A73F9CB.8000606@taunusstein.net>
In-Reply-To: <4A73F9CB.8000606@taunusstein.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After investigating source code following function caused my problem:

static int i802_bss_add(void *priv, const char *ifname, const u8 *bssid)
{
        int ifidx;

        /*
         * The kernel supports that when the low-level driver does,
         * but we currently don't because we need per-BSS data that
         * currently we can't handle easily.
         */
        return -1;

        ifidx = nl80211_create_iface(priv, ifname, NL80211_IFTYPE_AP,
bssid);
        if (ifidx < 0)
                return -1;
        if (hostapd_set_iface_flags(priv, ifname, 1)) {
                nl80211_remove_iface(priv, ifidx);
                return -1;
        }
        return 0;
}

Obviously hostapd does not support multiple SSIDs because that function
returns always an error.

It would be nice to mention that in documentation...

Christian

