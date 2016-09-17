Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42009 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbcIQPCA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:02:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
        <1474123851.7623.2.camel@sipsolutions.net>
Date: Sat, 17 Sep 2016 18:01:53 +0300
In-Reply-To: <1474123851.7623.2.camel@sipsolutions.net> (Johannes Berg's
        message of "Sat, 17 Sep 2016 16:50:51 +0200")
Message-ID: <87wpia7eou.fsf@kamboji.qca.qualcomm.com> (sfid-20160917_170209_995051_CE2C9CD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> I guess some of these static variables could be also const, but
>> didn't check.
>
> I think both bitrates and channels can't be, due to cfg80211 writing
> some (global) flags there on init.

Sorry, I was unclear. I meant the whole file, not just what was in my
mail:

qtnfmac/cfg80211.c:static struct ieee80211_rate qtnf_rates[] = {
qtnfmac/cfg80211.c:static struct ieee80211_channel qtnf_channels_2ghz[] = {
qtnfmac/cfg80211.c:static struct ieee80211_supported_band qtnf_band_2ghz = {
qtnfmac/cfg80211.c:static struct ieee80211_channel qtnf_channels_5ghz[] = {
qtnfmac/cfg80211.c:static struct ieee80211_supported_band qtnf_band_5ghz = {
qtnfmac/cfg80211.c:static struct cfg80211_ops qtn_cfg80211_ops = {
qtnfmac/pcie.c:static struct qtnf_bus_ops qtnf_pcie_bus_ops = {
qtnfmac/pcie.c:static struct attribute *qtnf_sysfs_entries[] = {
qtnfmac/pcie.c:static struct attribute_group qtnf_attrs_group = {
qtnfmac/pcie.c:static struct pci_device_id qtnf_pcie_devid_table[] = {
qtnfmac/pcie.c:static struct pci_driver qtnf_pcie_drv_data = {

Anyway, nothing important. Just something which I started to wonder
while reading the code.
 
-- 
Kalle Valo
