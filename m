Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:52842 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZCLOOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 10:14:12 -0400
Received: by yw-out-2324.google.com with SMTP id 5so997932ywh.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 07:14:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
Date: Thu, 12 Mar 2009 10:14:09 -0400
Message-ID: <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com> (sfid-20090312_151416_482579_1C9B83FE)
Subject: Re: Thanks for TX power patch
From: Bob Copeland <me@bobcopeland.com>
To: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 4:15 AM, Tulio Magno Quites Machado Filho
<tuliom@gmail.com> wrote:
> On Wed, Mar 11, 2009 at 12:39 AM, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
>> If I unload/reload the ath5k, it seems to work. but at next suspend =
to
>> disk, once =A0system hung, other time it showed many panic, in somet=
hing
>> related to page allocator (one even was in page_alloc_pages or so)
>
> I'm getting some Kernel oopses after unloading ath5k with Nick patche=
s.
> But I'm still debugging it to find where is the problem.

Ditto here.. looks like a bug in ath5k_eeprom_free_pcal_info(), which h=
as:

    struct ath5k_pdgain_info *pd =3D &chinfo->pd_curves[pdg];

    if (pd !=3D NULL) {
        kfree(pd->pd_step);
        kfree(pd->pd_pwr);
        kfree(pd);
    }

kfree(pd) looks wrong, because pd_curves is the kzalloc()ed part, not
the array elements themselves.  But I tried removing that and freeing
the pd_curves array outside of the loop and got more slab debugging
poop.  So, I punt for now.

Also, every alloc of pd_step, and pd_pwr can potentially leak earlier
allocated memory on ENOMEM.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
