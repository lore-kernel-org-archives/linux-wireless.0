Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52490 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbcG1IF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 04:05:29 -0400
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
Subject: [RFC v0 1/8] selftests: firmware: do not abort test too early
Date: Thu, 28 Jul 2016 09:55:05 +0200
Message-Id: <1469692512-16863-2-git-send-email-wagi@monom.org> (sfid-20160728_100536_251287_A12EFE52)
In-Reply-To: <1469692512-16863-1-git-send-email-wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

When running the test script you will get:

kselftest/firmware/fw_userhelper.sh: line 69: echo: write error: Resource temporarily unavailable

and stops right there. Because the script runs with the '-e' option
which will stop the script at any error.

We should stop there because we are trying to something wrong and get an
error reported back. Instead, ignore the error message and make sure we
do not stop the script by setting the last error code to true.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 tools/testing/selftests/firmware/fw_userhelper.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/firmware/fw_userhelper.sh b/tools/testing/selftests/firmware/fw_userhelper.sh
index b9983f8..2d244a7 100755
--- a/tools/testing/selftests/firmware/fw_userhelper.sh
+++ b/tools/testing/selftests/firmware/fw_userhelper.sh
@@ -66,7 +66,7 @@ NAME=$(basename "$FW")
 
 # Test failure when doing nothing (timeout works).
 echo 1 >/sys/class/firmware/timeout
-echo -n "$NAME" >"$DIR"/trigger_request
+echo -n "$NAME" >"$DIR"/trigger_request 2> /dev/null || true
 if diff -q "$FW" /dev/test_firmware >/dev/null ; then
 	echo "$0: firmware was not expected to match" >&2
 	exit 1
-- 
2.7.4
