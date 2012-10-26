Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp29.msg.oleane.net ([62.161.4.29]:37888 "EHLO
	smtp29.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab2JZJKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 05:10:37 -0400
From: =?utf-8?Q?C=C3=A9dric_Debarge_-_ACKSYS?= <cedric.debarge@acksys.fr>
To: "'Jouni Malinen'" <j@w1.fi>
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A31901411778@sbs2003.acksys.local> <1350996238.10322.7.camel@jlt4.sipsolutions.net> <01e901cdb2b6$a41df0b0$ec59d210$@acksys.fr> <20121025145106.GA11453@w1.fi>
In-Reply-To: <20121025145106.GA11453@w1.fi>
Subject: RE: TR: Clear data transit during WPA negociation in case of reassociation
Date: Fri, 26 Oct 2012 11:12:41 +0200
Message-ID: <021301cdb35a$0d992020$28cb6060$@acksys.fr> (sfid-20121026_111042_541268_8CB08081)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

	Your patch corrects the problem !!
	No unencrypted frame observed anymore.

	Thank you very much (and Johannes too). 

Regards,

Cédric DEBARGE

-----Message d'origine-----
De : Jouni Malinen [mailto:j@w1.fi] 
Envoyé : jeudi 25 octobre 2012 16:51
À : Cédric Debarge - ACKSYS
Cc : 'Johannes Berg'; linux-wireless@vger.kernel.org
Objet : Re: TR: Clear data transit during WPA negociation in case of reassociation

On Thu, Oct 25, 2012 at 03:42:56PM +0200, Cédric Debarge - ACKSYS wrote:
> 	Please find attached the wpa_supplicant log file (it is quite big because of the EAP-TLS) you asked for.

Could you please test this with the following change in wpa_supplicant?


diff --git a/src/eapol_supp/eapol_supp_sm.c b/src/eapol_supp/eapol_supp_sm.c index 851cf49..f90fb62 100644
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

