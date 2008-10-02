Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:22671 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYJBM4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 08:56:35 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1085186wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 05:56:35 -0700 (PDT)
Message-ID: <eb3ff54b0810020556s407728b9n772e7ae178761eee@mail.gmail.com> (sfid-20081002_145639_335658_915BA29A)
Date: Thu, 2 Oct 2008 15:56:35 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: remove redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c)
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2163_13850062.1222952195086"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2163_13850062.1222952195086
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

 - This patch (against the linux-wireless-next git tree) removes a
redundant check in ieee80211_master_start_xmit (net/mac80211/tx.c).

  In this method, there is no need to call again the
ieee80211_is_data() method; this is checked immediately before, in the
"if" command (we will not enter this block unless ieee80211_is_data()
is true, so that the "and" (&&) condition in that "if" command will be
fullfilled ).



Regards,
Rami Rosen

Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_2163_13850062.1222952195086
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flte2hdn0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS90eC5jIGIvbmV0L21hYzgwMjExL3R4LmMKaW5kZXgg
MGNjMmUyMy4uYTI5MjYwYyAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3R4LmMKKysrIGIvbmV0
L21hYzgwMjExL3R4LmMKQEAgLTEyOTYsNyArMTI5Niw2IEBAIGludCBpZWVlODAyMTFfbWFzdGVy
X3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAogCWlmIChpZWVlODAyMTFfdmlmX2lz
X21lc2goJm9zZGF0YS0+dmlmKSAmJgogCSAgICBpZWVlODAyMTFfaXNfZGF0YShoZHItPmZyYW1l
X2NvbnRyb2wpKSB7Ci0JCWlmIChpZWVlODAyMTFfaXNfZGF0YShoZHItPmZyYW1lX2NvbnRyb2wp
KSB7CiAJCQlpZiAoaXNfbXVsdGljYXN0X2V0aGVyX2FkZHIoaGRyLT5hZGRyMykpCiAJCQkJbWVt
Y3B5KGhkci0+YWRkcjEsIGhkci0+YWRkcjMsIEVUSF9BTEVOKTsKIAkJCWVsc2UKQEAgLTEzMDUs
NyArMTMwNCw2IEBAIGludCBpZWVlODAyMTFfbWFzdGVyX3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1
ZmYgKnNrYiwKIAkJCWlmIChtZW1jbXAob2Rldi0+ZGV2X2FkZHIsIGhkci0+YWRkcjQsIEVUSF9B
TEVOKSAhPSAwKQogCQkJCUlFRUU4MDIxMV9JRlNUQV9NRVNIX0NUUl9JTkMoJm9zZGF0YS0+dS5t
ZXNoLAogCQkJCQkJCSAgICAgZndkZWRfZnJhbWVzKTsKLQkJfQogCX0gZWxzZSBpZiAodW5saWtl
bHkob3NkYXRhLT52aWYudHlwZSA9PSBOTDgwMjExX0lGVFlQRV9NT05JVE9SKSkgewogCQlzdHJ1
Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YTsKIAkJc3RydWN0IGllZWU4MDIxMV9sb2Nh
bCAqbG9jYWwgPSBvc2RhdGEtPmxvY2FsOwo=
------=_Part_2163_13850062.1222952195086--
