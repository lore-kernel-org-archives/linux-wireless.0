Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:42104 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeCXDjq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 23:39:46 -0400
Received: by mail-qt0-f169.google.com with SMTP id j3so3148950qtn.9
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 20:39:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADsGw2YsVrTMtqbw08L=2UX0QX2vDFpL66jQqmgqJYh-QkrBOw@mail.gmail.com>
References: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com>
 <CADjYELzsP37RWTqJOSoevNy32E38e4=bkjDkY6A4F3exnDYadQ@mail.gmail.com>
 <CADsGw2a+u7dW3H3PF7jgJmj0A5oiQ1BbNuASW7v6192CC-U2gA@mail.gmail.com>
 <CADjYELxj5J3U4EvXP=wrr24manop824RVgauGXN5eRXATYL7Jg@mail.gmail.com> <CADsGw2YsVrTMtqbw08L=2UX0QX2vDFpL66jQqmgqJYh-QkrBOw@mail.gmail.com>
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Fri, 23 Mar 2018 22:39:45 -0500
Message-ID: <CADsGw2Y-xKNeOOSeUrHJ5qSqTBN2PspqCL188mFKU7hXc7P5Ag@mail.gmail.com> (sfid-20180324_044020_092696_4FAAA68B)
Subject: Re: Query on queues in mesh mode
To: Thomas Pedersen <thomas@eero.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas

I modified the code and tried to set the TXQ parameters for mesh
interface. I didn't observe any error.

However, I modified the ath9k driver code to verify default TXQ
parameters. But I am observing same values for all the queues and the
cwmin is looks different.

To my understanding, the configured parameters using netlink library
will get effect in driver queues..

nl80211 - cfg80211 - mac80211 - ath9k

Could you please let me know if I am doing something wrong.


wifi@wifi-VirtualBox:~/chaos/get_txq_code/chaos_calmer-15.05.1/build_dir/target-mips_34kc_uClibc-0.9.33.2/linux-ar71xx_generic/compat-wireless-2015-03-09$
quilt diff
Index: compat-wireless-2015-03-09/drivers/net/wireless/ath/ath9k/debug.c
===================================================================
--- compat-wireless-2015-03-09.orig/drivers/net/wireless/ath/ath9k/debug.c
+++ compat-wireless-2015-03-09/drivers/net/wireless/ath/ath9k/debug.c
@@ -639,6 +639,7 @@ static int read_file_queues(struct seq_f
 {
        struct ieee80211_hw *hw = dev_get_drvdata(file->private);
        struct ath_softc *sc = hw->priv;
+        struct ath_hw *ah = sc->sc_ah;
        struct ath_txq *txq;
        int i;
        static const char *qname[4] = {
@@ -648,6 +649,10 @@ static int read_file_queues(struct seq_f
        for (i = 0; i < IEEE80211_NUM_ACS; i++) {
                txq = sc->tx.txq_map[i];
                seq_printf(file, "(%s):  ", qname[i]);
+               seq_printf(file, "(%s): %u ", "cwmin", ah->txq[i].tqi_cwmin);
+               seq_printf(file, "(%s): %u ", "cwmax", ah->txq[i].tqi_cwmax);
+               seq_printf(file, "(%s): %u ", "aifs", ah->txq[i].tqi_aifs);
+               seq_printf(file, "(%s): %u ", "burst",
ah->txq[i].tqi_burstTime);
                print_queue(sc, txq, file);
        }

root@OpenWrt:~# cat /sys/kernel/debug/ieee80211/phy0/ath9k/queues
(VO):  (cwmin): 4294967295 (cwmax): 1023 (aifs): 2 (burst): 0 qnum: 3
qdepth:  0 ampdu-depth:  0 pending:   0 stopped: 0
(VI):  (cwmin): 4294967295 (cwmax): 1023 (aifs): 2 (burst): 0 qnum: 2
qdepth:  0 ampdu-depth:  0 pending:   0 stopped: 0
(BE):  (cwmin): 4294967295 (cwmax): 1023 (aifs): 2 (burst): 0 qnum: 1
qdepth:  0 ampdu-depth:  0 pending:   0 stopped: 0
(BK):  (cwmin): 4294967295 (cwmax): 1023 (aifs): 2 (burst): 0 qnum: 0
qdepth:  0 ampdu-depth:  0 pending:   0 stopped: 0
(CAB): qnum: 8 qdepth:  0 ampdu-depth:  0 pending:   0 stopped: 0

Best Regards
Phani

On Fri, Mar 16, 2018 at 10:41 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
> Thanks Thomas. I will try to hack the code and let you know.
>
> Best Regards
> Phani
>
> On Thu, Mar 15, 2018 at 5:31 PM, Thomas Pedersen <thomas@eero.com> wrote:
>> On Wed, Mar 7, 2018 at 8:39 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
>>> Hi Thomas
>>>
>>> Thank you for your reply.
>>>
>>> Could you please let me know how can I verify these queues on a mesh
>>> router? (I am using TPLink router with Ath9k chipset).
>>
>> try
>>
>> $ iw mesh0 mpath dump
>>
>> The mpath queue length is under the "QLEN" heading.
>>
>>> Also, the TXQ parameters can only be set if device is in AP or P2P
>>> mode. Do you have any idea why this restriction is in place?
>>
>> I don't think there is any reason modifying the queue parameters wouldn't work
>> in mesh mode. Why don't you hack up that code and give it a try.
>>
>>> https://github.com/torvalds/linux/blob/master/net/wireless/nl80211.c
>>>
>>> static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>>> {
>>>
>>>            if (info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS]) {
>>>            ....
>>>                    if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>>>                        netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>>>                                  return -EINVAL;
>>>            ...
>>> }
>>>
>>> Best Regards
>>> Phani
>>>
>>> On Tue, Mar 6, 2018 at 11:59 PM, Thomas Pedersen <thomas@eero.com> wrote:
>>>> On Thu, Mar 1, 2018 at 7:27 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
>>>>> Hi All
>>>>>
>>>>> I am trying to understand the queuing mechanism wireless mesh networks.
>>>>>
>>>>> As per AP mode is concerned, there are four queues (BK, BE, Vi, VO)
>>>>> and traffic is controlled based on CWmin, CWmax, AIFS and TxOP.
>>>>>
>>>>> Does, mesh mode also involve these queues? Does mesh mode have any
>>>>> queue or it is just a single queue?
>>>>
>>>> mesh mode maps to the different ACs like AP mode. The only additional
>>>> queue in mesh is the mpath->frame_queue, which may be used if an
>>>> active mpath for a given RA can't be found.
>>>>
>>>> --
>>>> thomas
>>
>>
>>
>> --
>> thomas
