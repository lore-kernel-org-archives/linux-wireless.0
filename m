Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37818 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbbIHOWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 10:22:24 -0400
Received: by igbni9 with SMTP id ni9so78165075igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 07:22:23 -0700 (PDT)
Date: Tue, 8 Sep 2015 09:22:08 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: add 2.4GHz regulatory rules for Cuba (CU)
Message-ID: <20150908142208.GB26645@ubuntu-hedt> (sfid-20150908_162228_581487_51C35AE6)
References: <1439299795-17359-1-git-send-email-xose.vazquez@gmail.com>
 <20150813143154.GA121347@ubuntu-hedt>
 <55EEE9CA.5010309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55EEE9CA.5010309@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 08, 2015 at 03:59:38PM +0200, Xose Vazquez Perez wrote:
> On 08/13/2015 04:31 PM, Seth Forshee wrote:
> 
> > On Tue, Aug 11, 2015 at 03:29:55PM +0200, Xose Vazquez Perez wrote:
> >> Resolución 127, 2011 - Reglamento Banda 2,4 GHz.:
> >> http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
> >>
> >> Cc: Seth Forshee <seth.forshee@canonical.com>
> >> Cc: linux-wireless@vger.kernel.org
> >> Cc: wireless-regdb@lists.infradead.org
> >> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> >> ---
> >>  db.txt | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/db.txt b/db.txt
> >> index 982db34..2edbf90 100644
> >> --- a/db.txt
> >> +++ b/db.txt
> >> @@ -275,6 +275,13 @@ country CR: DFS-FCC
> >>  	(5490 - 5730 @ 20), (24), DFS
> >>  	(5735 - 5835 @ 20), (30)
> >>  
> >> +# http://www.mincom.gob.cu/?q=marcoregulatorio
> >> +# - Redes Informáticas
> >> +# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
> >> +country CU: DFS-FCC
> >> +	(2400 - 2456 @ 40), (200 mW)
> >> +	(2456 - 2483.5 @ 40), (200 mW)
> >> +
> > 
> > Based on the Google translation of the document you linked to, I don't
> > see anything which would prevent merging these rules into one rule. Am I
> > missing something?
> 
> from http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
> page 7:
> 
> Artículo 4: Disposiciones de carácter técnico
> [..]
> 4.3.- No obstante lo anterior, los equipos que operen en las frecuencias entre 2456 y
> 2483,5 MHz pueden emplear valores de p.i.r.e superiores, cuando ello se justifique en
> beneficio de objetivos de interés nacional [...]
> 4.4.- Para estos casos es necesario obtener una autorización expresa de la Agencia
> [...]
> 
> If you grant an authorization, for 2456-2483.5 pire can be increased.

Okay, but for the purposes of this database that provision isn't going
to apply, and it seems you agree since you've listed both as having the
exact same power limit. So I'd still prefer that we make it a single
rule.

Thanks,
Seth
