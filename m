Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12001 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbbHEIjd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 04:39:33 -0400
From: Chor Teck Law <ctlaw@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: RE: [PATCH v5] Add new mac80211 driver mwlwifi.
Date: Wed, 5 Aug 2015 08:39:28 +0000
Message-ID: <1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com> (sfid-20150805_103940_536382_2C6E567C)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <1436455659.36587.131.camel@sakura.staff.proxad.net>
 <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
 <20150804220956.GA28583@sakura.staff.proxad.net>
In-Reply-To: <20150804220956.GA28583@sakura.staff.proxad.net>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Tuesday 04 Aug 2015 à 20:02:23 (+0300), Kalle Valo wrote:
> 
> > I haven't looked at the driver myself yet. Do you have any estimates
> > how much duplication there is?
> 

I do think that someone interested in this thread should compare the two drivers to decide if they want to accept mwlwifi (or we let it develop closed door). 

You will find the differences with some leverage. To make your comparison easier, here is the summary (excluding the patch1-patch6 improvements as per review feedbacks from Johannes and community):

mwlwifi functions leveraged from mwl8k:
- 802.11n setting for mac80211
- Functions needed to hook up to mac80211
- Interactions with mac80211 to establish BA streams
- Partial firmware APIs, some data fields
- Method to pass rx packets to mac80211 (but added with 11ac rate map/reports)

All others are different/new. Including some listed below:
- Different/new 11ac chipsets, including combo BT devices
- Added support for 11ac related settings and functions
- Added support for concurrent AP+STA functionalities with single firmware per chip
- Additional firmware APIs 
- Added functions to convert newly supported settings from mac80211 to firmware
- Different Tx datapath 
- Different Rx low level datapath (though data structure for receiving is same)
- Reorganized the files for future scalability and features addition (more to come)
- Addressed all (sort of) review feedbacks from patch1-patch6 of this submission

Files to compare:
- Mwlwifi: dev.h, fwcmd.h, fwdl.h, hostcmd.h, isr.h, rx.h, sysadpt.h, tx.h
fwcmd.c, fwdl.c, isr.c, mac80211.c, main.c, rx.c, tx.c
- mwl8k: mwl8k.c


Changes (based on feedbacks) since initial submission:

PATCH: mwlwifi version 10.3.0.2 (Initial submission)

1. Rename all files from mwl_xxx.x to xxx.x.
2. Remove debug.c and debug.h.
3. Use wiphy_xxxxx() to print out messages.
4. Take off unnecessary BUG_ON() checking.
5. Remove comments used to explain the purpose of the code block and take off static function pre-declaration.
6. Typo error, unnecessary comments, prefer comment style and use BIT MACRO instead of constant.
7. Use __le16 and __le32 for data structure related to F/W communication.
8. Take off MACRO for cpu_to_le16 and cpu_to_le32. Use them directly.
9. Fixing warning when using parse to check endian (C=2 CF="-D__CHECK_ENDIAN__").
10. Remove unused constants.
11. Remove MACRO for mdelay() and use it directly.
12. Revise one infinite loop code segment.
13. Rewrite one code segement to use switch.
14. Use static inline function mwl_dev_get_vif to replace MACRO MWL_VIF.
15. Use static inline function mwl_dev_get_sta to replace MACRO MWL_STA.
16. Remove MACRO IEEE80211_KEY_CONF.
17. Remove IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE and IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE.
18. RemoveMACRO for SPIN LOCK and let spin lock be attached to related data structure.
19. Define constants for power initization instead of using value 1 and 2.
20. Take off unused constants.
21. Use switch to rewrite two code segments.
22. Refine parameters for function mwl_tx_xmit().
23. Use external constant variable to export mac80211 function array.
24.Move isr related functions to isr.c and isr.h.
25. Remove bitfields from Tx and Rx descriptor data structure.
26. Use mask and shift operation on these fields to make sure they are endian independent.
27. Remove bitfields from F/W command data structure.
28. Use mask and shift operation on these fields to make sure they are endian independent.
29. Fix problem: "Tx rate information does not display correctly".

>>> PATCH v2: mwlwifi version 10.3.0.3

1. Remove IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454.
2. Add IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991.
3. Change copy right header and module license to GPL v2.
4. Replace copy right header with the one used by mac80211 in order to pass the checking of checkpatch.pl.
5. Separate F/W related structure and host driver related structure (mwl_tx_desc and mwl_tx_hndl).
6. Move host driver related fields from mwl_tx_desc to mwl_tx_hndl and define original field as __le32. In this way, F/W related structure will always be 32-bits alignment no matter host is 32-bits or 64-bits.
7. Let driver handle on mwl_tx_hndl.
8. Modify related tx.c to use this new data structure and remove MACROs as suggested from linux wireless.
9. Follow one line comment as suggested by linux wireless.
10. Create hostcmd.h and move related constants and structure to this header file.
11. Removce unused MACROs.

>>> PATCH v3: mwlwifi version 10.3.0.4

1. Change copyright header.
2. Fix typo error.
3. Replace wiphy_info() with wiphy_debug() for debug messages.
4. Add file MAINTAINERS.
5. Use proper spin lock.
6. Add "-D__CHECK_ENDIAN__" to Makefile.
7. Remove warnings from sparse.
8. Remove warnings from 64-bits gcc.

>>> PATCH v4: mwlwifi version 10.3.0.5

1. Add newline to all log messages.
2. Fix uncorrect error message.
3. Access dma mapped memeory directly instead of function writew().
4. Rewrite mwl_rx_ring_init() to take care of error exception.
5. Remove dependency on "MWIFIEX_PCIE=n".
6. Correct some messages.
7. Add note(warning) message to describe the difference between mwlwifi and mwifiex. The message also warns user to select one of these two drivers for 88W8897 module.

>>> PATCH v5: mwlwifi version 10.3.0.6

1. Correct wording for log messages.
2. Remove unnecessary code.
3. Change title to "Marvell 88W8864/88W8897 PCIe driver with AP support".
4. Remove "select OF".
5. Let the driver can still work even though CONFIG_OF is not defined.
6. Fix typo error.
7. Remove unused field.
8. Change type of cdd from u32 to bool.
9. Move request_irq from mwl_mac80211_start() to mwl_wl_init().
10. Move free_irq from mwl_mac80211_stop() to mwl_wl_deinit().
11. Modify "struct mwl_priv *priv; priv = hw->priv" to "struct mwl_priv *priv = hw->priv;" to reduce the length of code.
12. Change type of jiffies related variables from u32 to unsigned long.
13. Change wiphy_info() to wiphy_debug() for some debug messages.
14. Remove "#if SYSADPT_NUM_OF_DESC_DATA > 3 ...#endif".
15. Use correct PCI constant DMA_MASK_BIT(32).
16. Delete mac80211.h.
17. Move exported variable in mac80211.h to dev.h.
18. Check if macid is zero before decreasing it.
19. Modify some code segment to use switch instead of if..else.
20. Remove fields vif and is_sta from structure mwl_vif.
21. Remove field sta from structure mwl_sta.
22. Change MAX_WAIT_FW_COMPLETE_ITERATIONS from 10000 to 500.
23. Rewrite mwl_tx_init() and mwl_rx_init() according to suggestion from Linux wireless community.
24. Fix ccmp header endian problem.
25. Use pci_dma_mapping_error() to check mapping result of pci_map_single().
26. Correct PCI mapping constant.
27. Let code can pass the checking of checkpatch.pl.
28. Remove unnecessary code.
29. Change title of Kconfig from "Marvell 88W8864/88W8897 PCIe driver with AP support" to "Marvell Avastar 88W8864/88W8897 PCIe driver (mac80211 compatible)".

>>> PATCH v6: mwlwifi version 10.3.0.7


Last words, The mwl8k series had its history, since 2009 with the Topdog series (Beyond our scope to comment). The mwlwifi have been developed over past year or so for the Avastar AP chips, being nurtured on openwrt github - we will continue to maintain. We thought this submission could benefit broader community in mainline linuxwireless.

If the gate-keeper and community really feel that we cannot submit a new driver for new chipsets due to some history, we will respect the decision. But as said, we are not setting precedence. Those who knows other drivers can inspect their histories and variance.


Regards
Chor-Teck
