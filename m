Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.67.88.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793566006;
	b=MOfuW+wskIxQbO9DO1gzchaTxQuTc2dBrq0Z49BawZPIuE9zkJEhppJLMEOduDOetFZx
	 2JNGNLvz37VzoVCOFdMVaPjmFQ1OTt4PlQLf7v67QUmeEyn91A/i3RhXFKyFFnHMkG6Fk
	 aNRLweIA3J/ZQ8ZY7HenFZ4+yFMtSXVmYuh6Wr5bpUX95bbpfbSIk7ZDE+AdGf29Mk7oz
	 IjMUp0xd597sKu4Wfhq0DegPw1IB3M8oXGi1WjPrhA3agaA4h4xm9A9/Bjmc87VuLZrjd
	 heNzfKmZdZnSUUqMiopY5guLy0Fs4NjDZvYi2YdTQ2yBujsn54uRvg2PyyS1LTpkcPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793566006;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Message-Instance:
	 DKIM2-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4MbatKLTODKTQpYC24W25gcVFeiDsO6iS0REk0D8qvQ=;
	b=RGdK39UiLP0oISv7bY/77sj8RYNKwnzGUErUzukOJ1tbhA9I63Ir0IhUvyEcnE+Pb7ob
	 nB/5Q5PHn2XPxjaydKwufiA8aNa55qP7K4MmIUCUsQQmwU3/qva2gBS+zRue0HvJMnDxQ
	 iPaAA9s6Pm7AJXrlGERueZg23kEQmW1+4VfqrQH4+MRNMqZpeEkxgwmuIzmklV903bAAP
	 PeixwZcTvBU9DwqLf0FgsiiomEDuzhIfiD8S4+dhTzsV11+JAyl2kihWdSYv7poSA/bNr
	 EebEXrz+UUZ7Pwuohp/yWZw/pqNayC8BK2j595IN+Ph08RGxB3paE5h1hOAHlcbRetA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cubiculum.net;
	spf=pass smtp.mailfrom=cubiculum.net;
	dkim=pass header.d=cubiculum.net header.i=@cubiculum.net header.a=ed25519-sha256 header.s=202501e header.b=G7B3jNL0;
	dkim=pass header.d=cubiculum.net header.i=@cubiculum.net header.a=rsa-sha256 header.s=202501r header.b=W5ptZZ0s;
	arc=none smtp.remote-ip=152.67.88.11
Received: from mail.cubiculum.net (mail.cubiculum.net [152.67.88.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3707F606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:46:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3707F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cubiculum.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cubiculum.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass header.d=cubiculum.net header.i=@cubiculum.net header.a=ed25519-sha256 header.s=202501e header.b=G7B3jNL0;
	dkim=pass (2048-bit key, unprotected) header.d=cubiculum.net header.i=@cubiculum.net header.a=rsa-sha256 header.s=202501r header.b=W5ptZZ0s
DKIM-Signature: v=1; a=ed25519-sha256; s=202501e; d=cubiculum.net; c=relaxed/relaxed; r=y;
	h=Message-ID:Date:Subject:To:From; t=1793564031; bh=4MbatKLTODKTQpYC24W25gc
	VFeiDsO6iS0REk0D8qvQ=; b=G7B3jNL0PHxTh5H7ZgjZCvu9jzsFW6oJ5qhKMx8XXAItyv7xzS
	J2Pgbjbqz24NLN5Uk/NIv7bvUjVRhAV7vKDA==;
DKIM-Signature: v=1; a=rsa-sha256; s=202501r; d=cubiculum.net; c=relaxed/relaxed; r=y;
	h=Message-ID:Date:Subject:To:From; t=1793564031; bh=4MbatKLTODKTQpYC24W25gc
	VFeiDsO6iS0REk0D8qvQ=; b=W5ptZZ0sKy3g8qagZ063xKexjRBA5B4p0l4Wiv4HXeTYDs/2hu
	glc58F+XR7DPavVxKzHS1u6uE/wykjJaCrVjMFNRO39hJUdSk0csHUbiU6Dal2eaYV+johHhrcK
	DLF4B0rT7Tm17DT6gosjjsaaSRE7zDWE3Yy2I2ydf4oUiH0aJAo5AXViMikIbC61V/CYE6tM2CN
	AMALU3DMJmo7HotHh+yIIFREAuRnBy8J0VuM0Jda09lZUOJ0fgrkP/XIRoo2aIKzL946FT/vEbH
	VldqH5QZOFzpKgDoA/QHplwq6n6fNP8ceHlzSWySQuw+2SW8EjhBnpZbyMZXxquPpzA==;
Message-Instance: m=1; h=sha256:s8boO3mLrPUESk8HN3CYq9fXaLFlnnc3HDep1hgQ
	c8s=:zaty51dS0/9DW0B+yunRnsrsGq7R5DR4orCs4rbEfcg=;
DKIM2-Signature: i=1; m=1; t=1793564031; d=cubiculum.net; mf=PGtlcm5lbEBj
	dWJpY3VsdW0ubmV0Pg==; rt=PGtldmluX3lhbmdAcmVhbHRlay5jb20+,PHBrc2hpaEByZWFs
	dGVrLmNvbT4=,PGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ+,PGxpbnV4LXdpcmVsZXNzQHZn
	ZXIua2VybmVsLm9yZz4=; s=v2-ed25519-20260926:ed25519-sha256:qMkz5MIBQ1RDmf5s
	5l6s3W/JVLj+ic9AYqsHutCo6aG8f9JIHc3yfpkmuczY2NE7+llO3d53Pu8xW9U+bUJHAg==,
	v2-rsa-20260926:rsa-sha256:K2Dit6ePYI1QVoAGY8S6kGl88oxw+W6EHa4K4M4Qi0WQIH39
	rxFGF6XYu3FiwQWXjstiVqMPt5Yi2k0yhWSecQqlM4fDD11jVRVGbmRYnzGK26y45VORhdJz
	jDeQ8x7T+u85RpaTEM7a27YpElJ5AXzOeZ6dgfkIRHTlUsT/7fLHpqBXM5B3ywB4gv5epu8z
	6+ddwcaQUS6kJ04QXA36q2PqGon8jWMXARTd6UctaYowV+teMwt9gRcgYLzWS6zRNj4fABZB
	JxdiJFttG3us5uX+dNfnjd+ilnnvJVNNlgZ9NYyYTXZPF/Bs2csCZAvBTQ/6sViK3DPXMELv
	NcDGdA==;
From: rcfa <kernel@cubiculum.net>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH rtw-next] wifi: rtw89: take the interface off the active list when removing it
Date: Sun,  1 Nov 2026 20:13:44 +0000
Message-ID: <20261101201344.1107256-1-kernel@cubiculum.net>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An interface is on the channel manager's active list while one of its
links has a channel context: rtw89_chanctx_ops_assign_vif() adds it, and
rtw89_chanctx_ops_unassign_vif() removes it once no link has one left.
rtw89_ops_remove_interface() does not touch the list, so if mac80211
removes an interface whose links still have channel contexts, the
interface stays on it. The next rtw89_ops_add_interface() then finds the
vif off rtwvifs_list and re-initializes mgnt_entry, which active_list
still points to. The entry now points to itself, and every walk of the
active list loops forever.

mac80211 should not remove an interface in that state, but it can: an
association that completes after cfg80211 has left (NETDEV_GOING_DOWN)
is not torn down before ndo_stop, and ieee80211_do_stop() warns
"destroying interface with valid links" and removes the interface
anyway. That is being fixed in mac80211 separately; rtw89 should not
corrupt its list either way.

This was seen with an RTL8922AU (USB) on Linux 7.1.5 and wpa_supplicant
2.11 associating by MLO, when NetworkManager took the interface down in
the same second as the association completed. After the interface came
back up, wpa_supplicant's next scan spun in rtw89_hw_scan_start() ->
rtw89_hw_scan_set_extra_op_info() at "if (tmp == scan_rtwvif) continue;"
with the wiphy lock held, NetworkManager blocked on it holding RTNL, and
everything that needed RTNL hung until a reboot:

  destroying interface with valid links 0x0002
  WARNING: net/mac80211/iface.c:563 at ieee80211_do_stop+0x9d8/0xb50 [mac80211]
  ...
  rtw89_8922au_git 3-2:1.0: rtw89_ops_remove_interface: rtwvif link (link_id 0) is not active
  ...
  INFO: task NetworkManager:2502 blocked for more than 311 seconds.
  INFO: task NetworkManager:2502 is blocked on a mutex likely owned by task wpa_supplicant:39683.

Take the interface off the active list in rtw89_ops_remove_interface()
if it is still on it, and warn, since its channel contexts were never
unassigned.

Tested on Linux 7.1.5 with the out-of-tree copy of rtw89 at
github.com/morrownr/rtw89, which has the same code in the functions
involved, and an unpatched mac80211 with a test-only hook that ignores
the next
WLAN_REASON_DEAUTH_LEAVING deauthentication from cfg80211, so that an
associated interface taken down is still associated in
ieee80211_do_stop(). The new warning fired, and the next scan after the
interface came back up completed instead of looping. (mac80211 then
went on to oops in the state it was left in, which is the part the
mac80211 fix addresses.)

The problem was found with Claude Code (Claude Opus 5.5) while analysing
that hang, and this change and changelog were written in the same
session.

Fixes: 68ec751b2881 ("wifi: rtw89: chan: manage active interfaces")
Signed-off-by: rcfa <kernel@cubiculum.net>
---

Notes:
    Testing: the results above are from Linux 7.1.5 with the out-of-tree
    copy of the driver. This patch on rtw-next has been compile-tested only:
    x86_64 allmodconfig with gcc 16.2 (CONFIG_WERROR=y), rtw89/ with and
    without W=1, and sparse on mac80211.c, with no new warnings.
    
    The mac80211 side is posted separately, for wireless:
    "wifi: mac80211: deauthenticate on stop if an association just completed"

 drivers/net/wireless/realtek/rtw89/mac80211.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 9e6cafc492c4..c9d9964dd27d 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -269,6 +269,18 @@ static void rtw89_ops_remove_interface(struct ieee80211_hw *hw,
 	rtw89_vif_unset_link(rtwvif, RTW89_VIF_IDLE_LINK_ID);
 
 bottom:
+	/* If mac80211 removes the interface while its links still have channel
+	 * contexts, rtw89_chanctx_ops_unassign_vif() has not taken it off the
+	 * active list. Do it here: add_interface re-initializes mgnt_entry, and
+	 * an entry re-initialized while still linked makes every walk of the
+	 * active list loop forever.
+	 */
+	if (!list_empty(&rtwvif->mgnt_entry)) {
+		rtw89_warn(rtwdev, "%s: interface still in the active list\n",
+			   __func__);
+		list_del_init(&rtwvif->mgnt_entry);
+	}
+
 	list_del_init(&rtwvif->list);
 	rtw89_core_release_bit_map(rtwdev->hw_port, port);
 	rtw89_release_mac_id(rtwdev, macid);

base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.53.0

