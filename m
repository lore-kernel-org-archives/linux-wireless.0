Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:48342 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbZCBXQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 18:16:17 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1671660ywh.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 15:16:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 15:16:14 -0800
Message-ID: <7c8826910903021516t640aa84dxfbb61a278b69c740@mail.gmail.com> (sfid-20090303_001637_020843_E4DB4D3C)
Subject: Bug in iw prevents setting the "cook" monitor flag
From: Mike Cui <cuicui@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is an off by one error in interface.c of iw that prevents
passing of the cook flag when creating a monitor interface. The fix is
simple:


--- a/interface.c       2009-03-02 15:11:58.748078548 -0800
+++ b/interface.c       2009-03-02 15:12:14.695203787 -0800
@@ -36,7 +36,7 @@ static int parse_mntr_flags(int *_argc,
        while (argc) {
                int ok = 0;
                for (flag = __NL80211_MNTR_FLAG_INVALID;
-                    flag < NL80211_MNTR_FLAG_MAX; flag++) {
+                    flag < NL80211_MNTR_FLAG_MAX + 1; flag++) {
                        if (strcmp(*argv, mntr_flags[flag]) == 0) {
                                ok = 1;
                                /*
