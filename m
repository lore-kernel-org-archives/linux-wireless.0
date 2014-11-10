Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57000 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaKJKH1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 05:07:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XnlsW-0005WX-Ny
	for linux-wireless@vger.kernel.org; Mon, 10 Nov 2014 11:07:20 +0100
Received: from cantest1.felk.cvut.cz ([147.32.86.75])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 11:07:20 +0100
Received: from lisovy by cantest1.felk.cvut.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 11:07:20 +0100
To: linux-wireless@vger.kernel.org
From: Rostislav Lisovy <lisovy@gmail.com>
Subject: Re: [ath5k-devel] Rookie needs helps with ath5k basics
Date: Mon, 10 Nov 2014 10:07:10 +0000 (UTC)
Message-ID: <loom.20141110T105051-618@post.gmane.org> (sfid-20141110_110734_033535_F2FD8B22)
References: <loom.20140215T180245-390@post.gmane.org> <CAOpc7mFVD-+CgrFm+cBVkrOSoeQZ0TRk-jNE32D0S6rtYJp9_g@mail.gmail.com> <CAJ-Vmom7Pk09o9GPdRxEzCTinB2X9bvQE_g83nJ-1m9zD9804g@mail.gmail.com> <CAK4gkpzR=pS+XzCHLpQwzCNjaQmm7JoUE_NhVGK_mhj=EXgadw@mail.gmail.com> <CAK4gkpy8uvWJW9RaHqkxTiSza0Y+79owD=2K8V-VHf6qOH_bdA@mail.gmail.com> <CAHNKnsS_tD0GJj9xLJJM-Lf0Np=L208BeY+fwj1tnRTVU_gyjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Hernan and all the others;

Sergey Ryazanov <ryazanov.s.a@...> writes:
> 
> Cc linux-wireless since Rostislav Lisovy just working on adding
> 802.11p to the stack.
> 
> 2014-11-07 16:49 GMT+03:00 Hernán Maximiliano González Calderón
> <hernan.gonzalez.calderon@...>:
> > Hello everyone,
> >
> > I am still working to adapt the ath5k module to transmit in the
> > 5850..5925GHz range, in order to comply with IEEE 802.11p requirements.

802.11p implementation is not just about the "WNIC driver" modification -- 
some work has to be done in the cfg80211/mac80211 subsystem as well.
All the necessary changes are already in the mac80211-next git. To make
this work, you will need to modify the WNIC driver (as you are trying
to accomplish) + user-space configuration tool.
Some quick and dirty ath9k modification to support 5.9GHz is at
https://github.com/CTU-IIG/802.11p-linux/commits/its-g5_v2
(I read the other email pointing out that the EEPROM should contain
the information about the 5.9GHz channels so I am not sure how dangerous
is what I am doing). The 'iw' modification is at
https://github.com/CTU-IIG/802.11p-iw/tree/its-g5_v2
A bit obsolete but still helpful tutorial on how to run the thing is
at https://gist.github.com/lisovy/80dde5a792e774a706a9 (obsolete in
the sense that the ath9k driver modification should be rebased to
the newest mac80211-next).

The questions that are still unanswered (and will definitely require
more effort to answer) are the 802.11p standard interpretation
regarding the OCB mode / 5.9GHz usage limitation. More specific --
Is the 5.9GHz limited for ITS (Intelligent transportation system)
usage only. Or for any usage as long as it uses the OCB mode? If one
of this limitation is valid, who does actually define the restriction --
regulatory rules of particular countries?
Another question is if the OCB mode may be used outside the 5.9GHz range?
Do we need to define the OCB_ONLY flag for 5.9GHz channels in
CRDA/wireless-regdb?

Best regards;
Rostislav

