Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:43590 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYI2J4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 05:56:48 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1956719fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 02:56:46 -0700 (PDT)
Message-ID: <48E0A65A.2060102@gmail.com> (sfid-20080929_115652_725677_A64A14BE)
Date: Mon, 29 Sep 2008 11:56:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org, Jouni Malinen <j@w1.fi>
Subject: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've found out, that NL80211_CMD_GET_WIPHY reply doesn't fit into a message
socket buffer now. Used driver is ath5k.

There is also a bug in hostapd which waits for ACK forever when this error occur
in i802_get_hw_feature_data(). This code should be preceded by the test which is
after it IMO (not sure if result.error case too):
      if (!finished)
                err = nl_wait_for_ack(drv->nl_handle);


Here is the kernel debug output:

Legend:
E|band
F|channels count
Fc|channel|consumed msg room|msg size

nl80211_send_wiphy: E 0
nl80211_send_wiphy: F 26
nl80211_send_wiphy: Fc 0 92 3648
nl80211_send_wiphy: Fc 1 112 3648
nl80211_send_wiphy: Fc 2 132 3648
nl80211_send_wiphy: Fc 3 152 3648
nl80211_send_wiphy: Fc 4 172 3648
nl80211_send_wiphy: Fc 5 192 3648
nl80211_send_wiphy: Fc 6 212 3648
nl80211_send_wiphy: Fc 7 232 3648
nl80211_send_wiphy: Fc 8 252 3648
nl80211_send_wiphy: Fc 9 272 3648
nl80211_send_wiphy: Fc 10 292 3648
nl80211_send_wiphy: Fc 11 312 3648
nl80211_send_wiphy: Fc 12 328 3648
nl80211_send_wiphy: Fc 13 344 3648
nl80211_send_wiphy: Fc 14 360 3648
nl80211_send_wiphy: Fc 15 376 3648
nl80211_send_wiphy: Fc 16 392 3648
nl80211_send_wiphy: Fc 17 408 3648
nl80211_send_wiphy: Fc 18 424 3648
nl80211_send_wiphy: Fc 19 440 3648
nl80211_send_wiphy: Fc 20 456 3648
nl80211_send_wiphy: Fc 21 472 3648
nl80211_send_wiphy: Fc 22 488 3648
nl80211_send_wiphy: Fc 23 504 3648
nl80211_send_wiphy: Fc 24 520 3648
nl80211_send_wiphy: Fc 25 536 3648
nl80211_send_wiphy: E 1
nl80211_send_wiphy: F 194
nl80211_send_wiphy: Fc 0 720 3648
nl80211_send_wiphy: Fc 1 736 3648
nl80211_send_wiphy: Fc 2 752 3648
nl80211_send_wiphy: Fc 3 768 3648
nl80211_send_wiphy: Fc 4 784 3648
nl80211_send_wiphy: Fc 5 800 3648
nl80211_send_wiphy: Fc 6 816 3648
nl80211_send_wiphy: Fc 7 832 3648
nl80211_send_wiphy: Fc 8 848 3648
nl80211_send_wiphy: Fc 9 864 3648
nl80211_send_wiphy: Fc 10 880 3648
nl80211_send_wiphy: Fc 11 896 3648
nl80211_send_wiphy: Fc 12 912 3648
nl80211_send_wiphy: Fc 13 928 3648
nl80211_send_wiphy: Fc 14 944 3648
nl80211_send_wiphy: Fc 15 960 3648
nl80211_send_wiphy: Fc 16 976 3648
nl80211_send_wiphy: Fc 17 992 3648
nl80211_send_wiphy: Fc 18 1008 3648
nl80211_send_wiphy: Fc 19 1024 3648
nl80211_send_wiphy: Fc 20 1040 3648
nl80211_send_wiphy: Fc 21 1056 3648
nl80211_send_wiphy: Fc 22 1072 3648
nl80211_send_wiphy: Fc 23 1088 3648
nl80211_send_wiphy: Fc 24 1104 3648
nl80211_send_wiphy: Fc 25 1120 3648
nl80211_send_wiphy: Fc 26 1136 3648
nl80211_send_wiphy: Fc 27 1152 3648
nl80211_send_wiphy: Fc 28 1168 3648
nl80211_send_wiphy: Fc 29 1184 3648
nl80211_send_wiphy: Fc 30 1200 3648
nl80211_send_wiphy: Fc 31 1216 3648
nl80211_send_wiphy: Fc 32 1232 3648
nl80211_send_wiphy: Fc 33 1248 3648
nl80211_send_wiphy: Fc 34 1264 3648
nl80211_send_wiphy: Fc 35 1280 3648
nl80211_send_wiphy: Fc 36 1296 3648
nl80211_send_wiphy: Fc 37 1312 3648
nl80211_send_wiphy: Fc 38 1328 3648
nl80211_send_wiphy: Fc 39 1344 3648
nl80211_send_wiphy: Fc 40 1360 3648
nl80211_send_wiphy: Fc 41 1376 3648
nl80211_send_wiphy: Fc 42 1392 3648
nl80211_send_wiphy: Fc 43 1408 3648
nl80211_send_wiphy: Fc 44 1424 3648
nl80211_send_wiphy: Fc 45 1440 3648
nl80211_send_wiphy: Fc 46 1456 3648
nl80211_send_wiphy: Fc 47 1472 3648
nl80211_send_wiphy: Fc 48 1488 3648
nl80211_send_wiphy: Fc 49 1504 3648
nl80211_send_wiphy: Fc 50 1520 3648
nl80211_send_wiphy: Fc 51 1536 3648
nl80211_send_wiphy: Fc 52 1552 3648
nl80211_send_wiphy: Fc 53 1568 3648
nl80211_send_wiphy: Fc 54 1584 3648
nl80211_send_wiphy: Fc 55 1600 3648
nl80211_send_wiphy: Fc 56 1616 3648
nl80211_send_wiphy: Fc 57 1632 3648
nl80211_send_wiphy: Fc 58 1648 3648
nl80211_send_wiphy: Fc 59 1664 3648
nl80211_send_wiphy: Fc 60 1680 3648
nl80211_send_wiphy: Fc 61 1696 3648
nl80211_send_wiphy: Fc 62 1712 3648
nl80211_send_wiphy: Fc 63 1728 3648
nl80211_send_wiphy: Fc 64 1744 3648
nl80211_send_wiphy: Fc 65 1760 3648
nl80211_send_wiphy: Fc 66 1776 3648
nl80211_send_wiphy: Fc 67 1792 3648
nl80211_send_wiphy: Fc 68 1808 3648
nl80211_send_wiphy: Fc 69 1824 3648
nl80211_send_wiphy: Fc 70 1840 3648
nl80211_send_wiphy: Fc 71 1856 3648
nl80211_send_wiphy: Fc 72 1872 3648
nl80211_send_wiphy: Fc 73 1888 3648
nl80211_send_wiphy: Fc 74 1904 3648
nl80211_send_wiphy: Fc 75 1920 3648
nl80211_send_wiphy: Fc 76 1936 3648
nl80211_send_wiphy: Fc 77 1952 3648
nl80211_send_wiphy: Fc 78 1968 3648
nl80211_send_wiphy: Fc 79 1984 3648
nl80211_send_wiphy: Fc 80 2000 3648
nl80211_send_wiphy: Fc 81 2016 3648
nl80211_send_wiphy: Fc 82 2032 3648
nl80211_send_wiphy: Fc 83 2048 3648
nl80211_send_wiphy: Fc 84 2064 3648
nl80211_send_wiphy: Fc 85 2080 3648
nl80211_send_wiphy: Fc 86 2096 3648
nl80211_send_wiphy: Fc 87 2112 3648
nl80211_send_wiphy: Fc 88 2128 3648
nl80211_send_wiphy: Fc 89 2144 3648
nl80211_send_wiphy: Fc 90 2160 3648
nl80211_send_wiphy: Fc 91 2176 3648
nl80211_send_wiphy: Fc 92 2192 3648
nl80211_send_wiphy: Fc 93 2208 3648
nl80211_send_wiphy: Fc 94 2224 3648
nl80211_send_wiphy: Fc 95 2240 3648
nl80211_send_wiphy: Fc 96 2256 3648
nl80211_send_wiphy: Fc 97 2272 3648
nl80211_send_wiphy: Fc 98 2288 3648
nl80211_send_wiphy: Fc 99 2304 3648
nl80211_send_wiphy: Fc 100 2320 3648
nl80211_send_wiphy: Fc 101 2336 3648
nl80211_send_wiphy: Fc 102 2352 3648
nl80211_send_wiphy: Fc 103 2368 3648
nl80211_send_wiphy: Fc 104 2384 3648
nl80211_send_wiphy: Fc 105 2400 3648
nl80211_send_wiphy: Fc 106 2416 3648
nl80211_send_wiphy: Fc 107 2432 3648
nl80211_send_wiphy: Fc 108 2448 3648
nl80211_send_wiphy: Fc 109 2464 3648
nl80211_send_wiphy: Fc 110 2480 3648
nl80211_send_wiphy: Fc 111 2496 3648
nl80211_send_wiphy: Fc 112 2512 3648
nl80211_send_wiphy: Fc 113 2528 3648
nl80211_send_wiphy: Fc 114 2544 3648
nl80211_send_wiphy: Fc 115 2560 3648
nl80211_send_wiphy: Fc 116 2576 3648
nl80211_send_wiphy: Fc 117 2592 3648
nl80211_send_wiphy: Fc 118 2608 3648
nl80211_send_wiphy: Fc 119 2624 3648
nl80211_send_wiphy: Fc 120 2640 3648
nl80211_send_wiphy: Fc 121 2656 3648
nl80211_send_wiphy: Fc 122 2672 3648
nl80211_send_wiphy: Fc 123 2688 3648
nl80211_send_wiphy: Fc 124 2704 3648
nl80211_send_wiphy: Fc 125 2720 3648
nl80211_send_wiphy: Fc 126 2736 3648
nl80211_send_wiphy: Fc 127 2752 3648
nl80211_send_wiphy: Fc 128 2768 3648
nl80211_send_wiphy: Fc 129 2784 3648
nl80211_send_wiphy: Fc 130 2800 3648
nl80211_send_wiphy: Fc 131 2816 3648
nl80211_send_wiphy: Fc 132 2832 3648
nl80211_send_wiphy: Fc 133 2848 3648
nl80211_send_wiphy: Fc 134 2864 3648
nl80211_send_wiphy: Fc 135 2880 3648
nl80211_send_wiphy: Fc 136 2896 3648
nl80211_send_wiphy: Fc 137 2912 3648
nl80211_send_wiphy: Fc 138 2928 3648
nl80211_send_wiphy: Fc 139 2944 3648
nl80211_send_wiphy: Fc 140 2960 3648
nl80211_send_wiphy: Fc 141 2976 3648
nl80211_send_wiphy: Fc 142 2992 3648
nl80211_send_wiphy: Fc 143 3008 3648
nl80211_send_wiphy: Fc 144 3024 3648
nl80211_send_wiphy: Fc 145 3040 3648
nl80211_send_wiphy: Fc 146 3056 3648
nl80211_send_wiphy: Fc 147 3072 3648
nl80211_send_wiphy: Fc 148 3088 3648
nl80211_send_wiphy: Fc 149 3104 3648
nl80211_send_wiphy: Fc 150 3120 3648
nl80211_send_wiphy: Fc 151 3136 3648
nl80211_send_wiphy: Fc 152 3152 3648
nl80211_send_wiphy: Fc 153 3168 3648
nl80211_send_wiphy: Fc 154 3184 3648
nl80211_send_wiphy: Fc 155 3200 3648
nl80211_send_wiphy: Fc 156 3216 3648
nl80211_send_wiphy: Fc 157 3232 3648
nl80211_send_wiphy: Fc 158 3248 3648
nl80211_send_wiphy: Fc 159 3264 3648
nl80211_send_wiphy: Fc 160 3280 3648
nl80211_send_wiphy: Fc 161 3296 3648
nl80211_send_wiphy: Fc 162 3312 3648
nl80211_send_wiphy: Fc 163 3328 3648
nl80211_send_wiphy: Fc 164 3344 3648
nl80211_send_wiphy: Fc 165 3360 3648
nl80211_send_wiphy: Fc 166 3376 3648
nl80211_send_wiphy: Fc 167 3392 3648
nl80211_send_wiphy: Fc 168 3408 3648
nl80211_send_wiphy: Fc 169 3424 3648
nl80211_send_wiphy: Fc 170 3440 3648
nl80211_send_wiphy: Fc 171 3456 3648
nl80211_send_wiphy: Fc 172 3472 3648
nl80211_send_wiphy: Fc 173 3488 3648
nl80211_send_wiphy: Fc 174 3504 3648
nl80211_send_wiphy: Fc 175 3520 3648
nl80211_send_wiphy: Fc 176 3536 3648
nl80211_send_wiphy: Fc 177 3552 3648
nl80211_send_wiphy: Fc 178 3568 3648
nl80211_send_wiphy: Fc 179 3584 3648
nl80211_send_wiphy: Fc 180 3600 3648
nl80211_send_wiphy: Fc 181 3616 3648
nl80211_send_wiphy: Fc 182 3632 3648
nl80211_send_wiphy: Fc 183 3648 3648

