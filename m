Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58864 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2LJLJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 06:09:30 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on 60gHz band
Date: Mon, 10 Dec 2012 13:09:27 +0200
Message-ID: <1424987.QUc2GD1qWX@lx-vladimir> (sfid-20121210_120934_466865_9F91583E)
In-Reply-To: <1355134918.9857.9.camel@jlt4.sipsolutions.net>
References: <8774585.BvFN3Opv12@lx-vladimir> <1573921.0GjqNuABMd@lx-vladimir> <1355134918.9857.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, December 10, 2012 11:21:58 AM Johannes Berg wrote:
> On Mon, 2012-12-10 at 11:45 +0200, Vladimir Kondratiev wrote:
> 
> > For the 60gHz band, regulation defined in the "Etsi En 302 567"
> > http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html
> 
> > +country AD:
> > +        # 60 gHz band channels 1-4, ref: Etsi En 302 567
> > +        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> > +        (57240 - 65880 @ 2160), (N/A, 25)
> 
> There doesn't seem to be a bandwidth limitation in the rules, should we
> really put one into the database?
Yes, there is no limit and I'd want to remove bandwidth, but I don't see
how to do so. If I simply omit '@ 2160', I am getting error from db2bin.py:

$ ./db2bin.py regulatory.bin db.txt vkondrat.key.priv.pem 
Traceback (most recent call last):
  File "./db2bin.py", line 52, in <module>
    countries = p.parse(file(sys.argv[2]))
  File "/local/mnt/vkondrat/60ghz/wireless-regdb/dbparse.py", line 361, in parse
    self._parse_country_item(line)
  File "/local/mnt/vkondrat/60ghz/wireless-regdb/dbparse.py", line 268, in _parse_country_item
    self._syntax_error("Badly parenthesised band definition")
  File "/local/mnt/vkondrat/60ghz/wireless-regdb/dbparse.py", line 139, in _syntax_error
    raise SyntaxError("Syntax error in line %d%s" % (self._lineno, txt))
dbparse.SyntaxError: Syntax error in line 17 (Badly parenthesised band definition)

