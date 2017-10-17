Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38856 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753087AbdJQJE1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 05:04:27 -0400
Received: from mail-ua0-f175.google.com ([209.85.217.175])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <jesse.sung@canonical.com>)
        id 1e4NnW-0006ly-KZ
        for linux-wireless@vger.kernel.org; Tue, 17 Oct 2017 09:04:26 +0000
Received: by mail-ua0-f175.google.com with SMTP id z4so657188uaz.5
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 02:04:26 -0700 (PDT)
MIME-Version: 1.0
From: Jesse Sung <jesse.sung@canonical.com>
Date: Tue, 17 Oct 2017 17:04:25 +0800
Message-ID: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com> (sfid-20171017_110449_063483_9C0F4028)
Subject: Commit 0711d638 breaks mwifiex
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>
Cc: Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While working on an issue that marvell module stops connecting to AP,
bisect reveals that the issue starts to happen from commit 0711d638,
which uses wdev->ssid_len instead of wdev->current_bss to determine
if driver's .disconnect() should be called.

It happens because mwifiex_cfg80211_connect() returns -EALREADY
when it finds wdev->current_bss is valid:

if (priv->wdev.current_bss) {
    [PRINT LOG]
    return -EALREADY;
}

This would make cfg80211_connect() set wdev->ssid_len to 0, and thus
mwifiex_cfg80211_disconnect() won't be called by cfg80211_disconnect().

The easiest way to overcome this is

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 0a49b88..104edb4 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1142,7 +1142,7 @@ int cfg80211_disconnect(struct
cfg80211_registered_device *rdev,
                err = cfg80211_sme_disconnect(wdev, reason);
        else if (!rdev->ops->disconnect)
                cfg80211_mlme_down(rdev, dev);
-       else if (wdev->ssid_len)
+       else if (wdev->ssid_len || wdev->current_bss)
                err = rdev_disconnect(rdev, dev, reason);

        return err;

but I'm not sure if this is a proper fix for this issue.

Thanks,
Jesse
