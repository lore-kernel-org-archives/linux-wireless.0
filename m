Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:63773 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZGWL7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 07:59:50 -0400
Received: by yxe14 with SMTP id 14so315258yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 04:59:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090723112428.GC13742@hash.localnet>
References: <4A612514.4050708@redfish-solutions.com>
	 <4A635E04.4050204@redfish-solutions.com>
	 <20090719203150.GA9972@hash.localnet>
	 <4A63DF0B.4010801@redfish-solutions.com>
	 <20090720115244.GC9972@hash.localnet>
	 <4A64C283.6090205@redfish-solutions.com>
	 <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>
	 <4A650331.9020409@redfish-solutions.com>
	 <4A6620B9.4@redfish-solutions.com>
	 <20090723112428.GC13742@hash.localnet>
Date: Thu, 23 Jul 2009 07:59:49 -0400
Message-ID: <b6c5339f0907230459g75cef6eag1ad0caa7b1a631b8@mail.gmail.com>
Subject: Re: Using compat-wireless w/ 2.6.27.26
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 7:24 AM, Bob Copeland<me@bobcopeland.com> wrote:
> -       ath5k_tx_processq(sc, sc->txq);
> +       for (i=0; i < AR5K_NUM_TX_QUEUES; i++) {
> +               if (!sc->txqs[i].setup)
> +                       continue;
> +               ath5k_tx_processq(sc, sc->txq);

oops, should be:

ath5k_tx_processq(sc, sc->txqs[i]);

> +       }
>  }
>
-- 
Bob Copeland %% www.bobcopeland.com
