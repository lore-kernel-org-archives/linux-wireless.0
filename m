Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:52606 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756071AbaKERPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 12:15:52 -0500
Message-ID: <1415207747.6634.15.camel@perches.com> (sfid-20141105_181642_729141_BEA7AC1C)
Subject: Re: [PATCH v2] staging:rtl8723au: core: Fix error reported by
 checkpatch.
From: Joe Perches <joe@perches.com>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 09:15:47 -0800
In-Reply-To: <1415187303-28541-1-git-send-email-sanjeev_sharma@mentor.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
	 <1415187303-28541-1-git-send-email-sanjeev_sharma@mentor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-05 at 17:05 +0530, Sanjeev Sharma wrote:
> This is a patch to the rtw_cmd.c file that fixes
> Error reported by checkpatch.

Please run your patches through checkpatch before
sending them.

WARNING: suspect code indent for conditional statements (24, 24)
#178: FILE: drivers/staging/rtl8723au/core/rtw_cmd.c:1025:
+			if (check_fwstate(pmlmepriv, _FW_LINKED))
 			LPS_Leave23a(padapter);

Also, there are a couple of different things
you changing here.

This should be 2 separate patches.

One to use the temporary for:
+	struct rt_link_detect *ldi = &pmlmepriv->LinkDetectInfo;

(and that bit has a defect here:


+	} else {
 		LPS_Leave23a(padapter);
+		}

where the indentation for the last close brace is wrong)

and another for the whitespace only changes


