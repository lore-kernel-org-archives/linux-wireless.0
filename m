Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36501 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaKHQxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 11:53:50 -0500
Received: by mail-wi0-f179.google.com with SMTP id h11so7095126wiw.12
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2014 08:53:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <545CDF7F.70906@einfach.org>
References: <loom.20140215T180245-390@post.gmane.org>
	<CAOpc7mFVD-+CgrFm+cBVkrOSoeQZ0TRk-jNE32D0S6rtYJp9_g@mail.gmail.com>
	<CAJ-Vmom7Pk09o9GPdRxEzCTinB2X9bvQE_g83nJ-1m9zD9804g@mail.gmail.com>
	<CAK4gkpzR=pS+XzCHLpQwzCNjaQmm7JoUE_NhVGK_mhj=EXgadw@mail.gmail.com>
	<CAK4gkpy8uvWJW9RaHqkxTiSza0Y+79owD=2K8V-VHf6qOH_bdA@mail.gmail.com>
	<CAHNKnsS_tD0GJj9xLJJM-Lf0Np=L208BeY+fwj1tnRTVU_gyjA@mail.gmail.com>
	<545CDF7F.70906@einfach.org>
Date: Sat, 8 Nov 2014 08:53:49 -0800
Message-ID: <CAJ-Vmom-0bMiczcmMXVHs=eFxepcE82E3teLQF-GRq7Vq1=o5Q@mail.gmail.com> (sfid-20141108_175404_697440_29A73027)
Subject: Re: [ath5k-devel] Rookie needs helps with ath5k basics
From: Adrian Chadd <adrian@freebsd.org>
To: Bruno Randolf <br1@einfach.org>
Cc: Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	=?UTF-8?Q?Hern=C3=A1n_Maximiliano_Gonz=C3=A1lez_Calder=C3=B3n?=
	<hernan.gonzalez.calderon@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

right. The default NIC EEPROM setup doesn't include those channels
because they haven't tested them out.

If you have an 802.11p regulatory compliant NIC then it should have
the 11p frequencies show up in the EEPROM channel range.

So you should definitely first check that the NIC EEPROM has those as
available channels. :)



-adrian


On 7 November 2014 07:04, Bruno Randolf <br1@einfach.org> wrote:
> Hi,
>
> I don't remember all the details but there are various places which can
> limit the available channels in ath5k. Check
>
> ath5k_is_standard_channel()
> ath5k_setup_channels()
> ath5k_setup_bands()
>
> in drivers/net/wireless/ath/ath5k/base.c
>
> Good luck!
>
> bruno
>
> On 11/07/2014 02:27 PM, Sergey Ryazanov wrote:
>> Cc linux-wireless since Rostislav Lisovy just working on adding
>> 802.11p to the stack.
>>
>> 2014-11-07 16:49 GMT+03:00 Hernán Maximiliano González Calderón
>> <hernan.gonzalez.calderon@gmail.com>:
>>> Hello everyone,
>>>
>>> I am still working to adapt the ath5k module to transmit in the
>>> 5850..5925GHz range, in order to comply with IEEE 802.11p requirements. Our
>>> plan is to liberate the code to the community as soon as we develop it.
>>>
>>> I have already compiled a new regdomains database with wireless-regdb and
>>> crda, and we are using the module in ATH5K_TEST_CHANNELS mode. The database
>>> is now defined as follows:
>>>
>>> (2402 - 2472 @ 40), (3, 27)
>>> (5170 - 5250 @ 40), (3, 17)
>>> (5250 - 5330 @ 40), (3, 20)
>>> (5490 - 5600 @ 40), (3, 20)
>>> (5650 - 5710 @ 40), (3, 20)
>>> (5735 - 5835 @ 40), (3, 30)
>>> (5835 - 5925 @ 10), (3, 30)
>>>
>>> However, when I execute "iw wlan1 ibss join TFG 5850" it returns the -22
>>> error number, indicating that we are using a frequency not defined.
>>>
>>> 2014-02-19 17:22 GMT+01:00 Hernán Maximiliano González Calderón
>>> <hernan.gonzalez.calderon@gmail.com>:
>>>>
>>>> Thanks for the quick reply and sorry for not giving an answer until now,
>>>> but first I had to talk with my project advisor. The reason we chose ath5k
>>>> was that the cards we bought used it and all information we gather about
>>>> this kind of projects were related to that driver.
>>>>
>>>> I also have talked with my advisor and whatever we accomplish will come
>>>> back to the community.
>>>>
>>>> I am just starting with the project and I am needing some guides, the tips
>>>> and info you all gave me will be very helpful. I will keep on working and
>>>> will tell you if I get something done.
>>>>
>>>> Thanks a lot,
>>>> Hernán M. G. C.
>>>>
>>>>
>>>> 2014-02-18 2:03 GMT+01:00 Adrian Chadd <adrian@freebsd.org>:
>>>>>
>>>>> ... because some of the 802.11p NICs are actually ath5k NICs that have
>>>>> the relevant bandpass filters for 5.9GHz and high output amplifiers.
>>>>>
>>>>>
>>>>>
>>>>> -a
>>>>>
>>>>>
>>>>> On 17 February 2014 01:27, Holger Schurig <holgerschurig@gmail.com>
>>>>> wrote:
>>>>>> Okay, I admit that I cannot help you, I have no clue on the driver
>>>>>> level.
>>>>>>
>>>>>> But maybe I can help with the methodology. :-)
>>>>>>
>>>>>> You mention 802.11p (car-to-car-communication). Is there any specific
>>>>>> reason you base it on ath5k and not on ath9k?  If you look at the
>>>>>> number of commits, then you should see that ath9k is much more lively.
>>>>>> People are actively working with that code and might be able to be
>>>>>> answer more specific questions.
>>>>>> Another thing that I noted: I have seen over the years many requests
>>>>>> of information from uni projects in this mailing list. But I'm quite
>>>>>> unsure if ever something came back into the Linux kernel. How do you
>>>>>> plan to tackle that?  I have the feeling that people are more likely
>>>>>> to cooperate if the work doesn't end up in yet another black hole ...
>>>>>>
>>>>>> And one tip: ask specific questions, not broad ones. For example, look
>>>>>> at what features you need to implement 802.11p. Now look at what OSI
>>>>>> level this has to be done, e.g. at hardware level (frequency,
>>>>>> bandwidth), driver level, or protocoll layer (mac80211, user-space
>>>>>> layer (e.g. wpa_supplicant). That would allow you to ask questions not
>>>>>> like "Tell me everything", but "Oh, I need to do XYZ, where can I do
>>>>>> it?". It might even help you in finding your way, e.g. by looking into
>>>>>> git commits inside the ath/ath9k subdirectories that might have
>>>>>> something to do with what you need.
>>>>>> _______________________________________________
>>>>>> ath5k-devel mailing list
>>>>>> ath5k-devel@lists.ath5k.org
>>>>>> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>>
>
