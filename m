Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34914 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbcFCHBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 03:01:25 -0400
Received: by mail-yw0-f194.google.com with SMTP id n16so9837323ywd.2
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2016 00:01:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAfyv37zUXh+4g8Vr1Ee3ypfnA9ebNbx=xJ-cGBs3StaB-ANfQ@mail.gmail.com>
References: <CAAfyv37Sr7JRtfrZYyb=c530sK8PR_ymeJ6w38274i1aDkHZ8A@mail.gmail.com>
 <CABPxzYLe27gzQdEEU=5z6Bbmfduscjgry3gfQ6KRrWfngQt-Mg@mail.gmail.com> <CAAfyv37zUXh+4g8Vr1Ee3ypfnA9ebNbx=xJ-cGBs3StaB-ANfQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 3 Jun 2016 12:31:05 +0530
Message-ID: <CABPxzYKvcS-ai90Fzw70d0tcT9GT=N6UzJQ966Jas2xDCzvQbg@mail.gmail.com> (sfid-20160603_090128_911419_25D5F9CB)
Subject: Re: iw reg overwritten after connecting to AP
To: Belisko Marek <marek.belisko@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 3, 2016 at 2:02 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
>
> Hi Krishna,
>
> On Thu, Jun 2, 2016 at 10:21 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
> > On Thu, Jun 2, 2016 at 7:34 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> >>
> >> Hello,
> >>
> >> I'm using kernel 4.1 with option CONFIG_CFG80211_INTERNAL_REGDB
> >> enabled. I have set one country in db.txt which during startup I set
> >> via 'iw reg set XX'. When connected to some AP which sends country
> >> code (e.g. SK) region is overwritten to 00 (in kernel log there is
> >> some timeout message - I suppose it's communication with crda daemon
> >> which I'm not using). Is there a way how to override this behavior (to
> >> keep my regulatory persistent). Many thanks.
> >>
> > You need to disable country_ie hints, you driver has to advertise
> > REGULATORY_WIPHY_SELF_MANAGED in the wiphy.regualtory_flags
> > to disable beacon and country_ie hints.
> I would like to keep beacon hinting (maybe disable only country_ie). I
> have same setup but with 3.9 kernel and regulatory isn't overwritten.
>
>
> > Which driver are you using?
> I'm using mwifiex driver

I am not familiar with this driver.

But looks like for any other country except for WORLD mode
 it is disabling both beacon and country_ie hints. But for any
other country these hints are enabled.

may be you can try the below patch (not based on 4.1 so you might have to port)
for your case disabling country_ie for all regulatory domains.

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 6db202f..cb95138 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4072,8 +4072,9 @@ int mwifiex_register_cfg80211(struct
mwifiex_adapter *adapter)
        wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);

        if (adapter->region_code)
-               wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
-                                          REGULATORY_COUNTRY_IE_IGNORE;
+               wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS;
+
+       wiphy->regulatory_flags |= REGULATORY_COUNTRY_IE_IGNORE;

        ether_addr_copy(wiphy->perm_addr, adapter->perm_addr);
        wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
