Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:52789 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab2JYOvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 10:51:19 -0400
Date: Thu, 25 Oct 2012 17:51:06 +0300
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?Q?C=C3=A9dric?= Debarge - ACKSYS
	<cedric.debarge@acksys.fr>
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: TR: Clear data transit during WPA negociation in case of
 reassociation
Message-ID: <20121025145106.GA11453@w1.fi> (sfid-20121025_165122_565326_86DD19E6)
References: <773DB8A82AB6A046AE0195C68612A31901411778@sbs2003.acksys.local>
 <1350996238.10322.7.camel@jlt4.sipsolutions.net>
 <01e901cdb2b6$a41df0b0$ec59d210$@acksys.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <01e901cdb2b6$a41df0b0$ec59d210$@acksys.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 03:42:56PM +0200, Cédric Debarge - ACKSYS wrote:
> 	Please find attached the wpa_supplicant log file (it is quite big because of the EAP-TLS) you asked for.

Could you please test this with the following change in wpa_supplicant?


diff --git a/src/eapol_supp/eapol_supp_sm.c b/src/eapol_supp/eapol_supp_sm.c
index 851cf49..f90fb62 100644
--- a/src/eapol_supp/eapol_supp_sm.c
+++ b/src/eapol_supp/eapol_supp_sm.c
@@ -1469,10 +1469,7 @@ void eapol_sm_notify_cached(struct eapol_sm *sm)
 	if (sm == NULL)
 		return;
 	wpa_printf(MSG_DEBUG, "EAPOL: PMKSA caching was used - skip EAPOL");
-	sm->SUPP_PAE_state = SUPP_PAE_AUTHENTICATED;
-	sm->suppPortStatus = Authorized;
-	eapol_sm_set_port_authorized(sm);
-	sm->portValid = TRUE;
+	sm->eapSuccess = TRUE;
 	eap_notify_success(sm->eap);
 	eapol_sm_step(sm);
 }


-- 
Jouni Malinen                                            PGP id EFC895FA
