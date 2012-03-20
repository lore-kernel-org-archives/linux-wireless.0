Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33522 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2CTGCn (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 20 Mar 2012 02:02:43 -0400
Received: by bkcik5 with SMTP id ik5so4829574bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 23:02:23 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Mar 2012 14:02:22 +0800
Message-ID: <CALx5=V_czM-3sqhutbYx27wHnLtQL_PvcSjKHd4RGtopkKqf3A@mail.gmail.com> (sfid-20120320_070247_013413_2AAE94EF)
Subject: About the .start function in ieee80211_ops.
From: Matt Chen <machen@suse.com>
To: users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I have a issue recently for rt2800pci, the way to duplicate this is
1. Press function key to set rfkill hard blocked, it would cause
driver to power off.
2. reboot
3. find when load the driver (rt2800pci), it would stop in "Registered
led device: rt2800pci-phy0::quality".

Here you would find the rfkill_poll function is not started to work,
also the rt2x00mac_start() registered in rt2800pci_mac80211_ops
structure is not yet be executed.
My question is when or what condition the rt2x00mac_start()  would be
running, because if it is not yet executed, then it would not be able
to load the firmware in rt2x00lib_start().

In drivers/net/wireless/rt2x00/rt2800pci.c:
static const struct ieee80211_ops rt2800pci_mac80211_ops = {
        ...
        .start                  = rt2x00mac_start,
        .stop                   = rt2x00mac_stop,
        ...
        ...
};

in drivers/net/wireless/rt2x00/rt2x00mac.c:
int rt2x00mac_start(struct ieee80211_hw *hw)
{
        struct rt2x00_dev *rt2x00dev = hw->priv;
        if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
                return 0;
        return rt2x00lib_start(rt2x00dev);
}



-- 
Thank you.
