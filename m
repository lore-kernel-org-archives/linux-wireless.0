Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45831 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZJBKAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 06:00:36 -0400
Date: Fri, 2 Oct 2009 19:00:29 +0900
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattia Dongili <malattia@linux.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org
Subject: Re: sony-laptop: check for rfkill hard block at load time
Message-ID: <20091002100029.GC4406@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="p4qYPpj5QlsIQJ0K"
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, 24 Sep 2009, Alan Jenkins wrote:
> We can fix this by querying the firmware at load time and calling
> rfkill_set_hw_state().

The bug concerning checking the state after suspend to ram should probably
be also queued. Original email attached.

Tested-by: Norbert Preining <preining@logic.at>

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
SWANAGE (pl.n.)
Swanage is the series of diversionary tactics used when trying to
cover up the existence of a glossop (q.v.) and may include (a)
uttering a high-pitched laugh and pointing out of the window (NB. this
doesn't work more that twice); (b) sneezing as loudly as possible and
wiping the glossop off the table in the same movement as whipping out
your handkerchief; (c) saying 'Christ! I seen to have dropped some
shit on your table' (very unwise); (d) saying 'Christ, who did that?'
(better) (e) pressing your elbow on the glossop itself and working
your arms slowly to the edge of the table; (f) leaving the glossop
where it is but moving a plate over it and putting up with sitting at
an uncomfortable angle the rest of the meal; or, if the glossop is in
too exposed a position, (g) leaving it there unremarked except for the
occasional humorous glance.
			--- Douglas Adams, The Meaning of Liff

--p4qYPpj5QlsIQJ0K
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <alan.christopher.jenkins@googlemail.com>
Envelope-to: preining@logic.at
Delivery-date: Fri, 25 Sep 2009 11:18:29 +0200
Received: from mx.logic.tuwien.ac.at ([128.130.175.19])
	by gamma.logic.tuwien.ac.at with esmtp (Exim 4.69)
	(envelope-from <alan.christopher.jenkins@googlemail.com>)
	id 1Mr6we-0003ug-VR
	for preining@logic.at; Fri, 25 Sep 2009 11:18:29 +0200
Received: from dspam by mx.logic.tuwien.ac.at with spam-scanned (Exim 4.69)
	(envelope-from <alan.christopher.jenkins@googlemail.com>)
	id 1Mr6we-0007sX-UD
	for preining@logic.at; Fri, 25 Sep 2009 11:18:28 +0200
Received: from mail-bw0-f206.google.com ([209.85.218.206])
	by mx.logic.tuwien.ac.at with esmtp (Exim 4.69)
	(envelope-from <alan.christopher.jenkins@googlemail.com>)
	id 1Mr6we-0007sQ-Q2
	for preining@logic.at; Fri, 25 Sep 2009 11:18:28 +0200
Received: by bwz2 with SMTP id 2so1874718bwz.23
        for <preining@logic.at>; Fri, 25 Sep 2009 02:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=gamma;
        h=domainkey-signature:received:received:sender:message-id:date:from
         :user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding;
        bh=LwWk89iEAG1NlmLy91MPmiG4i497Rvr4RlTOzGwlcy8=;
        b=v5NXcIUb2JpReRR4hjEMoYtEw0zWO05kZMZOihvPz15iYT9jRj+4l2rBmNlzZvGMMT
         03p8BPKc60BKTvQUTOyEkkWXjawqOEUaOyHxEuERVBZyVCSD/YxS+u9lWPNc/a4LWuiv
         3DloMeuhLWTq4QGuiMvtFxmL1+OKXmU6SnJcc=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=sdO+ysONNKKfDPkndiYI5XJO62q8g2eVungoUAfng1IqDZSy3Dl8PZxiGNHsksWdK3
         A8wVmTiFXcnuWV3FQdjeLaRzgwmjP6R900SVKH48Baa/UzgldSZQeGKW9EjZampzhFW7
         bB/X8zDsY/NHsh3G9LFafFPqqCF3Xlol10WdA=
Received: by 10.204.8.72 with SMTP id g8mr3949652bkg.199.1253870303416;
        Fri, 25 Sep 2009 02:18:23 -0700 (PDT)
Received: from ?192.168.0.5? ([86.53.68.233])
        by mx.google.com with ESMTPS id k29sm531510fkk.57.2009.09.25.02.18.22
        (version=SSLv3 cipher=RC4-MD5);
        Fri, 25 Sep 2009 02:18:23 -0700 (PDT)
Sender: Alan Jenkins <alan.christopher.jenkins@googlemail.com>
Message-ID: <4ABC8ADD.3090803@tuffmail.co.uk>
Date: Fri, 25 Sep 2009 10:18:21 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 Mattia Dongili <malattia@linux.it>,
 Norbert Preining <preining@logic.at>
Subject: [PATCH] [RFT] sony-laptop: re-read the rfkill state when resuming
 from suspend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-FILTER-DSPAM: by mx.logic.tuwien.ac.at 
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Sep 25 11:18:28 2009
X-DSPAM-Confidence: 0.8949
X-DSPAM-Improbability: 1 in 852 chance of being spam
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4abc8ae4302871591419864
X-DSPAM-Factors: 27,
	From*Alan Jenkins <alan-jenkins@tuffmail.co.uk>, 0.00069,
	switch, 0.00896,
	device), 0.01000,
	From*Alan, 0.01000,
	diff, 0.01000,
	static, 0.03076,
	off+by, 0.04656,
	Signed, 0.05753,
	uk>, 0.06426,
	CC*logic.at>, 0.08020,
	hardware, 0.08354,
	0+}, 0.11649,
	int, 0.12673,
	(and, 0.12860,
	Alan, 0.13643,
	restore, 0.14271,
	laptop, 0.14578,
	laptop, 0.14578,
	if+the, 0.15940,
	code, 0.18988,
	DKIM-Signature*h=domainkey, 0.19597,
	DKIM-Signature*signature, 0.19597,
	DKIM-Signature*sha256+c=relaxed/relaxed, 0.19601,
	DKIM-Signature*a=rsa+sha256, 0.19602,
	DKIM-Signature*sha256, 0.19624,
	DKIM-Signature*h=domainkey+signature, 0.20015,
	DomainKey-Signature*s=gamma, 0.20279

Without this, the hard-blocked state will be reported incorrectly if
the hardware switch is changed while the laptop is suspended.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
--

Again, this is from code inspection only.  Since suspend/resume can
be tricky, please test that this change works (and is necessary).


diff a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1044,6 +1044,9 @@ static int sony_nc_resume(struct acpi_device *device)
 			sony_backlight_update_status(sony_backlight_device) < 0)
 		printk(KERN_WARNING DRV_PFX "unable to restore brightness level\n");
 
+	/* re-read rfkill state */
+	sony_nc_rfkill_update();
+
 	return 0;
 }
 


--p4qYPpj5QlsIQJ0K--
