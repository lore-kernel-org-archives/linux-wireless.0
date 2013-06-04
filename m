Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60257 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab3FDA6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 20:58:22 -0400
Received: by mail-pd0-f175.google.com with SMTP id 5so2866350pdd.20
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 17:58:22 -0700 (PDT)
Received: from [10.33.2.158] (a82-202.nat.uq.edu.au. [130.102.82.202])
        by mx.google.com with ESMTPSA id pm7sm21879753pbb.31.2013.06.03.17.58.19
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 03 Jun 2013 17:58:20 -0700 (PDT)
Message-ID: <51AD3BA9.30809@gmail.com> (sfid-20130604_025834_849745_88FD2CB5)
Date: Tue, 04 Jun 2013 10:58:17 +1000
From: Peizhao Hu <peiworld@gmail.com>
Reply-To: peiworld@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: missing break statement when searching for section cmd
Content-Type: multipart/mixed;
 boundary="------------030203040804010104030008"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030203040804010104030008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


-- 
regards;

Peizhao


--------------030203040804010104030008
Content-Type: text/x-patch;
 name="iw.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iw.patch"

diff --git a/iw.c b/iw.c
index dc99566..4051a18 100644
--- a/iw.c
+++ b/iw.c
@@ -359,8 +359,10 @@ static int __handle_cmd(struct nl80211_state *state, enum id_input idby,
 		/* ok ... bit of a hack for the dupe 'info' section */
 		if (match && sectcmd->idby != command_idby)
 			continue;
-		if (strcmp(sectcmd->name, section) == 0)
+		if (strcmp(sectcmd->name, section) == 0){
 			match = sectcmd;
+			break;
+		}
 	}
 
 	sectcmd = match;

--------------030203040804010104030008--
