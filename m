Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933071AbdKBJaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 05:30:19 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/3] staging: rtl8188eu: Fix bug introduced by convert timers to use timer_setup()
Date: Thu,  2 Nov 2017 10:30:12 +0100
Message-Id: <20171102093013.10745-2-hdegoede@redhat.com> (sfid-20171102_103023_263852_1F8D7334)
In-Reply-To: <20171102093013.10745-1-hdegoede@redhat.com>
References: <20171102093013.10745-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit b7749656e946 ("staging: rtl8188eu: Convert timers to use
timer_setup()") introduces a copy and paste error which causes the
rtl8188eu driver to no longer function. This commit fixes this.

Fixes: b7749656e946 ("staging: rtl8188eu: Convert timers to use timer_setup()")
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index d717046a6c2f..d73e9bdc80cc 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -4806,7 +4806,7 @@ void linked_status_chk(struct adapter *padapter)
 void survey_timer_hdl(struct timer_list *t)
 {
 	struct adapter *padapter = from_timer(padapter, t,
-					    mlmeextpriv.link_timer);
+					      mlmeextpriv.survey_timer);
 	struct cmd_obj	*ph2c;
 	struct sitesurvey_parm	*psurveyPara;
 	struct cmd_priv					*pcmdpriv = &padapter->cmdpriv;
-- 
2.14.2
