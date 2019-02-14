Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873F7C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 23:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52FD32175B
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 23:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="LI5b4Xxl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfBNXfF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 18:35:05 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:55586 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbfBNXfE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 18:35:04 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 046BD40B2CD
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 15:35:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com 046BD40B2CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1550187302;
        bh=AR1UKbTQu3utYFTyyg1ROqXFCCz/3Pgpxkl02j92ujw=;
        h=To:From:Subject:Date:From;
        b=LI5b4XxlzbBMv79tZtK3cLAowLW2rcAbSVQc0erSLh70qwExnSnQ2PRcAlDfKbi9V
         LmWBRjEU+Pcv9DgRqhSZrYK5OTa6S2rQ1oYTiQKYg0UqJc5Cod5d0/qgR4TAEhxOp4
         PMpHJXlhJSvFvYHu+aFP246z1Fo1t6B8zJV/PhHE=
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: WARN-ON in eee80211_vif_release_channel in 4.20.2+, ath10k
Organization: Candela Technologies
Message-ID: <f84f7f26-a299-3ae0-25e0-139880480532@candelatech.com>
Date:   Thu, 14 Feb 2019 15:35:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I was attempting 6 vap devices on one radio using my hacked ath10k driver and firmware...

I'm using ch 100 to make it even more buggy.

It is having issues, and one thing I saw is this WARN_ON hit:

void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
{
	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));

	lockdep_assert_held(&sdata->local->mtx);

	mutex_lock(&sdata->local->chanctx_mtx);
	__ieee80211_vif_release_channel(sdata);
	mutex_unlock(&sdata->local->chanctx_mtx);
}

There are no obvious errors in the logs immediately preceeding this, but several
more similar splats hit lower.

[ 3225.690458] WARNING: CPU: 0 PID: 30791 at net/mac80211/chan.c:1760 ieee80211_vif_release_channel+0x18/0x50 [mac80211]
[ 3225.690460] Modules linked in: ath10k_pci ath10k_core nf_conntrack_netlink nfnetlink iptable_raw xt_CT nf_conntrack bluetooth nf_defrag_ipv6 nf_defrag_ipv4 
libcrc32c bpfilter vrf 8021q garp mrp stp llc fuse macvlan wanlink(O) pktgen nfsv3 nfs fscache snd_hda_codec_hdmi coretemp snd_hda_intel intel_rapl 
x86_pkg_temp_thermal snd_hda_codec intel_powerclamp snd_hda_core kvm_intel snd_hwdep iTCO_wdt iTCO_vendor_support snd_seq ath kvm snd_seq_device snd_pcm 
irqbypass mac80211 joydev snd_timer snd cfg80211 i2c_i801 soundcore intel_pch_thermal mei_wdt acpi_pad pcc_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc 
sch_fq_codel igb hwmon serio_raw e1000e dca i915 i2c_algo_bit drm_kms_helper drm i2c_core video ipv6 crc_ccitt [last unloaded: ath10k_core]
[ 3225.690492] CPU: 0 PID: 30791 Comm: kworker/u8:4 Tainted: G        W  O      4.20.2+ #3
[ 3225.690493] Hardware name: _ _/, BIOS 5.11 08/26/2016
[ 3225.690506] Workqueue: phy11 ieee80211_dfs_cac_timer_work [mac80211]
[ 3225.690517] RIP: 0010:ieee80211_vif_release_channel+0x18/0x50 [mac80211]
[ 3225.690518] Code: bd ea ff ff ff eb a9 66 66 2e 0f 1f 84 00 00 00 00 00 53 48 8b 87 18 0c 00 00 48 89 fb 48 85 c0 74 0a 48 8b 40 48 a8 04 75 02 <0f> 0b 48 8b 
83 20 0c 00 00 48 8d b8 b8 20 00 00 e8 13 bd 31 e1 48
[ 3225.690519] RSP: 0018:ffffc900031e3e60 EFLAGS: 00010246
[ 3225.690520] RAX: 0000000000000003 RBX: ffff88813be0c940 RCX: ffff88816d824020
[ 3225.690520] RDX: ffff888135641e40 RSI: ffff88813d0990b0 RDI: ffff88813be0c940
[ 3225.690521] RBP: ffff88816d824000 R08: 0000000000000000 R09: 0000003131796870
[ 3225.690521] R10: 8080808080808080 R11: 0000000000000000 R12: ffff88813d03cd00
[ 3225.690522] R13: 0000000000000000 R14: ffff888169d8fc00 R15: 0ffff88813d03cd2
[ 3225.690523] FS:  0000000000000000(0000) GS:ffff888172c00000(0000) knlGS:0000000000000000
[ 3225.690523] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3225.690524] CR2: 000055714bd5eaf0 CR3: 000000000220a005 CR4: 00000000003606f0
[ 3225.690525] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3225.690525] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 3225.690526] Call Trace:
[ 3225.690539]  ieee80211_dfs_cac_timer_work+0x8c/0xb0 [mac80211]
[ 3225.690542]  process_one_work+0x1f3/0x410
[ 3225.690544]  worker_thread+0x28/0x3c0
[ 3225.690546]  ? wq_calc_node_cpumask+0x70/0x70
[ 3225.690547]  kthread+0x10b/0x130
[ 3225.690548]  ? kthread_create_on_node+0x60/0x60
[ 3225.690550]  ret_from_fork+0x1f/0x30
[ 3225.690552] ---[ end trace b4302d8e8360d501 ]---

Eventually, log is filled with this:

[ 3227.469556] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.531081] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.592435] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.653867] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.715322] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.776834] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.838186] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.899703] ath10k_pci 0000:04:00.0: could not get mac80211 beacon
[ 3227.961149] ath10k_pci 0000:04:00.0: could not get mac80211 beacon

Any ideas for places to look for bugs are welcome.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

