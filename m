Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52506 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbcG1IFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:34 -0400
From: Daniel Wagner <wagi@monom.org>
To: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 2/8] selftests: firmware: do not clutter output
Date: Thu, 28 Jul 2016 09:55:06 +0200
Message-Id: <1469692512-16863-3-git-send-email-wagi@monom.org> (sfid-20160728_100602_463832_B66A6B13)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Some of the test are supposed to fail but we get a few ouptput lines:

./fw_filesystem.sh: line 51: printf: write error: Invalid argument
./fw_filesystem.sh: line 56: printf: write error: No such device
./fw_filesystem.sh: line 62: echo: write error: No such file or directory

Let's silence them so that the selftest output is clean if all is fine.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 tools/testing/selftests/firmware/fw_filesystem.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/testing/selftests/firmware/fw_filesystem.sh
index 5c495ad..d8ac9ba 100755
--- a/tools/testing/selftests/firmware/fw_filesystem.sh
+++ b/tools/testing/selftests/firmware/fw_filesystem.sh
@@ -48,18 +48,18 @@ echo "ABCD0123" >"$FW"
 
 NAME=$(basename "$FW")
 
-if printf '\000' >"$DIR"/trigger_request; then
+if printf '\000' >"$DIR"/trigger_request 2> /dev/null; then
 	echo "$0: empty filename should not succeed" >&2
 	exit 1
 fi
 
-if printf '\000' >"$DIR"/trigger_async_request; then
+if printf '\000' >"$DIR"/trigger_async_request 2> /dev/null; then
 	echo "$0: empty filename should not succeed (async)" >&2
 	exit 1
 fi
 
 # Request a firmware that doesn't exist, it should fail.
-if echo -n "nope-$NAME" >"$DIR"/trigger_request; then
+if echo -n "nope-$NAME" >"$DIR"/trigger_request 2> /dev/null; then
 	echo "$0: firmware shouldn't have loaded" >&2
 	exit 1
 fi
-- 
2.7.4
