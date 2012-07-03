Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512Ab2GCX7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 19:59:31 -0400
Received: by pbbrp8 with SMTP id rp8so10047041pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 16:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF38492.20003@gmail.com>
References: <1341350730-11037-1-git-send-email-xose.vazquez@gmail.com> <4FF38492.20003@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 3 Jul 2012 16:59:11 -0700
Message-ID: <CAB=NE6VpCUr1v400bNa1R3Ns4S4QVUt-cjq8=XtoJY=U533Cig@mail.gmail.com> (sfid-20120704_015935_842525_465AA55D)
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for ES (Spain) on 5GHz and 2.4GHz
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 4:47 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On 07/03/2012 11:25 PM, Xose Vazquez Perez wrote:
>>
>> Spanish law was based on CEPT/EU rules:
>> http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html
>> http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000059.html
>>
>>
>> Orden ITC/332/2010, de 12 de febrero, por la que se aprueba el cuadro
>> nacional de atribución de frecuencias (CNAF):
>> https://www.boe.es/diario_boe/txt.php?id=BOE-A-2010-2719
>> https://www.boe.es/boe/dias/2010/02/19/pdfs/BOE-A-2010-2719.pdf
>>
>> search for:
>>   UN - 85 RLANs y datos en 2400 a 2483,5 MHz (pag. 213)
>>   UN – 128 RLANs en 5 GHz (pag. 232)
>>
>> more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
>> http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
>>
>> ---
>>   db.txt |    8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/db.txt b/db.txt
>> index 4c54543..11409d6 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -239,10 +239,10 @@ country EG:
>>         (5250 - 5330 @ 20), (N/A, 20), DFS
>>
>>   country ES: DFS-ETSI
>> -       (2402 - 2482 @ 40), (N/A, 20)
>> -       (5170 - 5250 @ 40), (N/A, 20)
>> -       (5250 - 5330 @ 40), (N/A, 20), DFS
>> -       (5490 - 5710 @ 40), (N/A, 27), DFS
>> +       (2400 - 2483.5 @ 40), (N/A, 100 mW)
>> +       (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>> +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>> +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS
>>
>>   country FI: DFS-ETSI
>>         (2402 - 2482 @ 40), (N/A, 20)
>>
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Please send a new patch and if you are going to convert something form
dBm to mW then please do that in *one* single patch so that it can
easily be read what changes you are *actually* making. That is one
patch to make a conversion in units that will not make any actual
changes, and then send another patch with all the verbiage you can use
to explain *why* you want the change you are making. You want the
commit log to have enough language so that if I forward the patch to a
regulatory person who has never read a patch they can read it.

The agreed upon "bar" for quality of regulatory patches was agreed
upon a while ago, for details see:

http://marc.info/?l=linux-wireless&m=128414096127554&w=2

The more information you can provide the better.

  Luis
